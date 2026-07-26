from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import List
from datetime import datetime, timezone
import uuid

from app.core.database import get_db
from app.core.deps import get_current_restaurant_user
from app.models.user import User
from app.models.inventory import InventoryItem, StockMovement
from app.schemas.inventory import TransferCreate, TransferOut

router = APIRouter()


@router.post("", response_model=TransferOut, status_code=201)
async def create_transfer(
    body: TransferCreate,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    if body.from_branch_id == body.to_branch_id:
        raise HTTPException(400, "Source and destination branches must be different")

    transfer_id = str(uuid.uuid4())
    transfer_items = []

    for t_item in body.items:
        item_res = await db.execute(
            select(InventoryItem).where(
                InventoryItem.id == t_item.item_id,
                InventoryItem.restaurant_id == user.restaurant_id,
            )
        )
        inv = item_res.scalar_one_or_none()
        if not inv:
            raise HTTPException(404, f"Item {t_item.item_id} not found")
        if float(inv.current_stock) < t_item.quantity:
            raise HTTPException(400, f"Insufficient stock for {inv.name}: available {inv.current_stock}")

        # Deduct from source
        inv.current_stock = float(inv.current_stock) - t_item.quantity
        inv.updated_at = datetime.now(timezone.utc)
        db.add(inv)

        out_movement = StockMovement(
            item_id=inv.id, restaurant_id=user.restaurant_id,
            branch_id=body.from_branch_id,
            movement_type="transfer_out", quantity=-t_item.quantity,
            unit_cost=float(inv.cost_per_unit), reference_id=transfer_id,
            reference_type="transfer", notes=body.notes, performed_by=user.id,
        )
        in_movement = StockMovement(
            item_id=inv.id, restaurant_id=user.restaurant_id,
            branch_id=body.to_branch_id,
            movement_type="transfer_in", quantity=t_item.quantity,
            unit_cost=float(inv.cost_per_unit), reference_id=transfer_id,
            reference_type="transfer", notes=body.notes, performed_by=user.id,
        )
        db.add(out_movement)
        db.add(in_movement)
        transfer_items.append({"item_id": inv.id, "item_name": inv.name, "quantity": t_item.quantity, "unit": inv.unit})

    return TransferOut(
        id=transfer_id,
        from_branch_id=body.from_branch_id,
        to_branch_id=body.to_branch_id,
        status="completed",
        items=transfer_items,
        notes=body.notes,
        created_at=datetime.now(timezone.utc),
    )


@router.get("", response_model=List[dict])
async def list_transfers(
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(StockMovement).where(
            StockMovement.restaurant_id == user.restaurant_id,
            StockMovement.movement_type == "transfer_out",
        ).order_by(StockMovement.created_at.desc()).limit(50)
    )
    movements = result.scalars().all()
    return [
        {
            "id": m.reference_id,
            "item_id": m.item_id,
            "quantity": abs(float(m.quantity)),
            "from_branch_id": m.branch_id,
            "notes": m.notes,
            "created_at": m.created_at.isoformat(),
        }
        for m in movements
    ]
