from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from typing import List, Optional
from datetime import datetime, timezone

from app.core.database import get_db
from app.core.deps import get_current_restaurant_user
from app.models.user import User
from app.models.inventory import Purchase, PurchaseItem, InventoryItem, StockMovement, InventoryBatch
from app.schemas.inventory import PurchaseCreate, PurchaseOut, PurchaseItemOut, PurchaseReceiveRequest

router = APIRouter()


async def _build_purchase_out(purchase: Purchase, db: AsyncSession) -> PurchaseOut:
    out = PurchaseOut.model_validate(purchase)
    if purchase.supplier:
        out.supplier_name = purchase.supplier.name

    item_outs = []
    for pi in purchase.items:
        pio = PurchaseItemOut.model_validate(pi)
        # Load item name
        ir = await db.execute(select(InventoryItem).where(InventoryItem.id == pi.item_id))
        inv = ir.scalar_one_or_none()
        if inv:
            pio.item_name = inv.name
            pio.item_unit = inv.unit
        pio.total_cost = round(float(pi.ordered_qty) * float(pi.unit_cost), 2)
        item_outs.append(pio)
    out.items = item_outs
    return out


@router.get("", response_model=List[PurchaseOut])
async def list_purchases(
    status: Optional[str] = None,
    supplier_id: Optional[str] = None,
    skip: int = 0,
    limit: int = 50,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    q = select(Purchase).where(Purchase.restaurant_id == user.restaurant_id)
    if status:
        q = q.where(Purchase.status == status)
    if supplier_id:
        q = q.where(Purchase.supplier_id == supplier_id)
    q = q.order_by(Purchase.created_at.desc()).offset(skip).limit(limit)
    result = await db.execute(q)
    purchases = result.scalars().all()
    return [await _build_purchase_out(p, db) for p in purchases]


@router.post("", response_model=PurchaseOut, status_code=201)
async def create_purchase(
    body: PurchaseCreate,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    # Generate PO number
    count_res = await db.execute(select(Purchase).where(Purchase.restaurant_id == user.restaurant_id))
    count = len(count_res.scalars().all()) + 1
    po_number = f"PO-{datetime.now().strftime('%Y%m')}-{count:04d}"

    total = sum(i.ordered_qty * i.unit_cost for i in body.items)

    purchase = Purchase(
        restaurant_id=user.restaurant_id,
        branch_id=body.branch_id,
        supplier_id=body.supplier_id,
        po_number=po_number,
        status="ordered",
        total_amount=total,
        expected_at=body.expected_at,
        notes=body.notes,
        created_by=user.id,
    )
    db.add(purchase)
    await db.flush()

    for item_data in body.items:
        pi = PurchaseItem(
            purchase_id=purchase.id,
            item_id=item_data.item_id,
            ordered_qty=item_data.ordered_qty,
            received_qty=0,
            unit_cost=item_data.unit_cost,
            expiry_date=item_data.expiry_date,
            batch_number=item_data.batch_number,
            notes=item_data.notes,
        )
        db.add(pi)

    await db.flush()
    await db.refresh(purchase)
    return await _build_purchase_out(purchase, db)


@router.get("/{purchase_id}", response_model=PurchaseOut)
async def get_purchase(
    purchase_id: str,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Purchase).where(Purchase.id == purchase_id, Purchase.restaurant_id == user.restaurant_id)
    )
    p = result.scalar_one_or_none()
    if not p:
        raise HTTPException(404, "Purchase not found")
    return await _build_purchase_out(p, db)


@router.post("/{purchase_id}/receive", response_model=PurchaseOut)
async def receive_purchase(
    purchase_id: str,
    body: PurchaseReceiveRequest,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    """Mark items as received — updates stock automatically."""
    result = await db.execute(
        select(Purchase).where(Purchase.id == purchase_id, Purchase.restaurant_id == user.restaurant_id)
    )
    purchase = result.scalar_one_or_none()
    if not purchase:
        raise HTTPException(404, "Purchase not found")
    if purchase.status == "received":
        raise HTTPException(400, "Purchase already fully received")

    for entry in body.items:
        pi_res = await db.execute(select(PurchaseItem).where(PurchaseItem.id == entry.purchase_item_id))
        pi = pi_res.scalar_one_or_none()
        if not pi:
            continue

        pi.received_qty = float(pi.received_qty) + entry.received_qty

        # Update inventory stock
        item_res = await db.execute(select(InventoryItem).where(InventoryItem.id == pi.item_id))
        inv_item = item_res.scalar_one_or_none()
        if inv_item:
            inv_item.current_stock = float(inv_item.current_stock) + entry.received_qty
            inv_item.cost_per_unit = pi.unit_cost  # Update cost
            db.add(inv_item)

            # Create movement record
            movement = StockMovement(
                item_id=pi.item_id, restaurant_id=user.restaurant_id,
                movement_type="purchase", quantity=entry.received_qty,
                unit_cost=float(pi.unit_cost), reference_id=purchase.id,
                reference_type="purchase", performed_by=user.id,
                notes=body.notes,
            )
            db.add(movement)

            # Create batch if expiry tracking
            if inv_item.expiry_tracking and (entry.expiry_date or pi.expiry_date):
                batch = InventoryBatch(
                    item_id=pi.item_id,
                    quantity=entry.received_qty,
                    expiry_date=entry.expiry_date or pi.expiry_date,
                    batch_number=entry.batch_number or pi.batch_number,
                    cost_per_unit=float(pi.unit_cost),
                    supplier_id=purchase.supplier_id,
                )
                db.add(batch)

        db.add(pi)

    # Check if fully received
    all_items_res = await db.execute(select(PurchaseItem).where(PurchaseItem.purchase_id == purchase_id))
    all_items = all_items_res.scalars().all()
    all_received = all(float(pi.received_qty) >= float(pi.ordered_qty) for pi in all_items)
    any_received = any(float(pi.received_qty) > 0 for pi in all_items)

    purchase.status = "received" if all_received else ("partial" if any_received else purchase.status)
    purchase.received_at = datetime.now(timezone.utc) if all_received else None
    purchase.updated_at = datetime.now(timezone.utc)
    db.add(purchase)

    await db.flush()
    await db.refresh(purchase)
    return await _build_purchase_out(purchase, db)


@router.delete("/{purchase_id}", status_code=204)
async def cancel_purchase(
    purchase_id: str,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Purchase).where(Purchase.id == purchase_id, Purchase.restaurant_id == user.restaurant_id)
    )
    p = result.scalar_one_or_none()
    if not p:
        raise HTTPException(404, "Purchase not found")
    p.status = "cancelled"
    db.add(p)
