from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_
from typing import List, Optional
from datetime import datetime, timezone, date, timedelta

from app.core.database import get_db
from app.core.deps import get_current_restaurant_user
from app.models.user import User
from app.models.inventory import InventoryItem, InventoryBatch, StockMovement
from app.schemas.inventory import (
    InventoryItemCreate, InventoryItemUpdate, InventoryItemOut,
    StockAdjustRequest, StockMovementOut, BatchCreate, BatchOut,
    StockCountRequest, StockCountResult, InventoryDashboard,
)

router = APIRouter()


def _stock_status(current: float, minimum: float) -> str:
    if current <= 0:
        return "out"
    if current <= minimum * 0.5:
        return "critical"
    if current <= minimum:
        return "low"
    return "ok"


def _expiry_status(expiry_date: date) -> tuple[str, int]:
    today = date.today()
    days = (expiry_date - today).days
    if days < 0:
        return "expired", days
    if days <= 3:
        return "urgent", days
    if days <= 7:
        return "warning", days
    return "ok", days


# ─── Dashboard ────────────────────────────────────────────────────────────────

@router.get("/dashboard", response_model=InventoryDashboard)
async def get_inventory_dashboard(
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    rid = user.restaurant_id
    if not rid:
        raise HTTPException(400, "Restaurant not configured")

    # All items
    items_res = await db.execute(
        select(InventoryItem).where(InventoryItem.restaurant_id == rid, InventoryItem.is_active == True)
    )
    items = items_res.scalars().all()

    low_stock = [i for i in items if _stock_status(float(i.current_stock), float(i.min_stock)) in ("low", "critical")]
    out_stock = [i for i in items if float(i.current_stock) <= 0]
    total_value = sum(float(i.current_stock) * float(i.cost_per_unit) for i in items)
    categories = set(i.category for i in items if i.category)

    # Expiring batches
    warn_date = date.today() + timedelta(days=7)
    batch_res = await db.execute(
        select(InventoryBatch).where(
            InventoryBatch.expiry_date != None,
            InventoryBatch.expiry_date <= warn_date,
            InventoryBatch.quantity > 0,
        ).order_by(InventoryBatch.expiry_date)
    )
    batches = batch_res.scalars().all()

    # Recent movements (last 20)
    mov_res = await db.execute(
        select(StockMovement)
        .where(StockMovement.restaurant_id == rid)
        .order_by(StockMovement.created_at.desc())
        .limit(20)
    )
    movements = mov_res.scalars().all()

    # Build item name lookup
    item_map = {i.id: i for i in items}

    def _item_out(item):
        out = InventoryItemOut.model_validate(item)
        out.stock_value = round(float(item.current_stock) * float(item.cost_per_unit), 2)
        out.stock_status = _stock_status(float(item.current_stock), float(item.min_stock))
        return out

    def _batch_out(b):
        out = BatchOut.model_validate(b)
        it = item_map.get(b.item_id)
        out.item_name = it.name if it else None
        if b.expiry_date:
            out.expiry_status, out.days_until_expiry = _expiry_status(b.expiry_date)
        return out

    def _mov_out(m):
        out = StockMovementOut.model_validate(m)
        it = item_map.get(m.item_id)
        out.item_name = it.name if it else None
        return out

    return InventoryDashboard(
        total_items=len(items),
        total_categories=len(categories),
        low_stock_count=len(low_stock),
        out_of_stock_count=len(out_stock),
        expiring_soon_count=len(batches),
        total_stock_value=round(total_value, 2),
        low_stock_items=[_item_out(i) for i in low_stock[:10]],
        expiring_soon=[_batch_out(b) for b in batches[:10]],
        recent_movements=[_mov_out(m) for m in movements],
    )


# ─── CRUD Items ───────────────────────────────────────────────────────────────

@router.get("/items", response_model=List[InventoryItemOut])
async def list_items(
    category: Optional[str] = None,
    status: Optional[str] = None,
    search: Optional[str] = None,
    branch_id: Optional[str] = None,
    skip: int = 0,
    limit: int = 100,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    q = select(InventoryItem).where(
        InventoryItem.restaurant_id == user.restaurant_id,
        InventoryItem.is_active == True,
    )
    if category:
        q = q.where(InventoryItem.category == category)
    if branch_id:
        q = q.where(InventoryItem.branch_id == branch_id)
    if search:
        q = q.where(InventoryItem.name.ilike(f"%{search}%"))
    q = q.offset(skip).limit(limit).order_by(InventoryItem.name)

    result = await db.execute(q)
    items = result.scalars().all()

    outs = []
    for item in items:
        out = InventoryItemOut.model_validate(item)
        out.stock_value = round(float(item.current_stock) * float(item.cost_per_unit), 2)
        out.stock_status = _stock_status(float(item.current_stock), float(item.min_stock))
        outs.append(out)

    if status:
        outs = [o for o in outs if o.stock_status == status]
    return outs


@router.post("/items", response_model=InventoryItemOut, status_code=201)
async def create_item(
    body: InventoryItemCreate,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    item = InventoryItem(**body.model_dump(), restaurant_id=user.restaurant_id)
    db.add(item)
    await db.flush()
    await db.refresh(item)
    out = InventoryItemOut.model_validate(item)
    out.stock_status = _stock_status(float(item.current_stock), float(item.min_stock))
    return out


@router.get("/items/{item_id}", response_model=InventoryItemOut)
async def get_item(
    item_id: str,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(InventoryItem).where(InventoryItem.id == item_id, InventoryItem.restaurant_id == user.restaurant_id)
    )
    item = result.scalar_one_or_none()
    if not item:
        raise HTTPException(404, "Item not found")
    out = InventoryItemOut.model_validate(item)
    out.stock_value = round(float(item.current_stock) * float(item.cost_per_unit), 2)
    out.stock_status = _stock_status(float(item.current_stock), float(item.min_stock))
    return out


@router.put("/items/{item_id}", response_model=InventoryItemOut)
async def update_item(
    item_id: str,
    body: InventoryItemUpdate,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(InventoryItem).where(InventoryItem.id == item_id, InventoryItem.restaurant_id == user.restaurant_id)
    )
    item = result.scalar_one_or_none()
    if not item:
        raise HTTPException(404, "Item not found")
    for field, value in body.model_dump(exclude_none=True).items():
        setattr(item, field, value)
    item.updated_at = datetime.now(timezone.utc)
    db.add(item)
    out = InventoryItemOut.model_validate(item)
    out.stock_status = _stock_status(float(item.current_stock), float(item.min_stock))
    return out


@router.delete("/items/{item_id}", status_code=204)
async def delete_item(
    item_id: str,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(InventoryItem).where(InventoryItem.id == item_id, InventoryItem.restaurant_id == user.restaurant_id)
    )
    item = result.scalar_one_or_none()
    if not item:
        raise HTTPException(404, "Item not found")
    item.is_active = False
    db.add(item)


@router.post("/items/{item_id}/adjust", response_model=StockMovementOut)
async def adjust_stock(
    item_id: str,
    body: StockAdjustRequest,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(InventoryItem).where(InventoryItem.id == item_id, InventoryItem.restaurant_id == user.restaurant_id)
    )
    item = result.scalar_one_or_none()
    if not item:
        raise HTTPException(404, "Item not found")

    item.current_stock = float(item.current_stock) + body.quantity
    item.updated_at = datetime.now(timezone.utc)

    movement = StockMovement(
        item_id=item_id,
        restaurant_id=user.restaurant_id,
        movement_type=body.movement_type,
        quantity=body.quantity,
        unit_cost=float(item.cost_per_unit),
        notes=body.notes,
        performed_by=user.id,
    )
    db.add(item)
    db.add(movement)
    await db.flush()
    await db.refresh(movement)
    return StockMovementOut.model_validate(movement)


# ─── Movements ────────────────────────────────────────────────────────────────

@router.get("/movements", response_model=List[StockMovementOut])
async def list_movements(
    item_id: Optional[str] = None,
    movement_type: Optional[str] = None,
    skip: int = 0,
    limit: int = 50,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    q = select(StockMovement).where(StockMovement.restaurant_id == user.restaurant_id)
    if item_id:
        q = q.where(StockMovement.item_id == item_id)
    if movement_type:
        q = q.where(StockMovement.movement_type == movement_type)
    q = q.order_by(StockMovement.created_at.desc()).offset(skip).limit(limit)
    result = await db.execute(q)
    return [StockMovementOut.model_validate(m) for m in result.scalars().all()]


# ─── Expiry / Batches ────────────────────────────────────────────────────────

@router.get("/batches", response_model=List[BatchOut])
async def list_batches(
    expiring_within_days: Optional[int] = None,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    q = select(InventoryBatch, InventoryItem).join(
        InventoryItem, InventoryBatch.item_id == InventoryItem.id
    ).where(
        InventoryItem.restaurant_id == user.restaurant_id,
        InventoryBatch.quantity > 0,
    )
    if expiring_within_days is not None:
        cutoff = date.today() + timedelta(days=expiring_within_days)
        q = q.where(InventoryBatch.expiry_date <= cutoff)
    q = q.order_by(InventoryBatch.expiry_date)

    result = await db.execute(q)
    rows = result.all()

    outs = []
    for batch, item in rows:
        out = BatchOut.model_validate(batch)
        out.item_name = item.name
        if batch.expiry_date:
            out.expiry_status, out.days_until_expiry = _expiry_status(batch.expiry_date)
        outs.append(out)
    return outs


@router.post("/batches", response_model=BatchOut, status_code=201)
async def create_batch(
    body: BatchCreate,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(InventoryItem).where(InventoryItem.id == body.item_id, InventoryItem.restaurant_id == user.restaurant_id)
    )
    item = result.scalar_one_or_none()
    if not item:
        raise HTTPException(404, "Item not found")

    batch = InventoryBatch(**body.model_dump())
    item.current_stock = float(item.current_stock) + body.quantity

    movement = StockMovement(
        item_id=body.item_id, restaurant_id=user.restaurant_id,
        movement_type="purchase", quantity=body.quantity,
        unit_cost=body.cost_per_unit, performed_by=user.id,
    )
    db.add(batch)
    db.add(item)
    db.add(movement)
    await db.flush()
    await db.refresh(batch)

    out = BatchOut.model_validate(batch)
    out.item_name = item.name
    if batch.expiry_date:
        out.expiry_status, out.days_until_expiry = _expiry_status(batch.expiry_date)
    return out


# ─── Stock Count ─────────────────────────────────────────────────────────────

@router.post("/stock-count", response_model=List[StockCountResult])
async def perform_stock_count(
    body: StockCountRequest,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    results = []
    for entry in body.items:
        res = await db.execute(
            select(InventoryItem).where(InventoryItem.id == entry.item_id, InventoryItem.restaurant_id == user.restaurant_id)
        )
        item = res.scalar_one_or_none()
        if not item:
            continue

        expected = float(item.current_stock)
        diff = entry.actual_qty - expected
        cost_impact = diff * float(item.cost_per_unit)

        # Record adjustment
        movement = StockMovement(
            item_id=item.id, restaurant_id=user.restaurant_id,
            movement_type="count", quantity=diff,
            unit_cost=float(item.cost_per_unit),
            notes=entry.notes or body.notes,
            performed_by=user.id,
        )
        item.current_stock = entry.actual_qty
        item.updated_at = datetime.now(timezone.utc)
        db.add(item)
        db.add(movement)

        results.append(StockCountResult(
            item_id=item.id, item_name=item.name, unit=item.unit,
            expected_qty=expected, actual_qty=entry.actual_qty,
            difference=round(diff, 3), cost_impact=round(cost_impact, 2),
        ))
    return results


# ─── Categories ──────────────────────────────────────────────────────────────

@router.get("/categories")
async def list_categories(
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(InventoryItem.category).where(
            InventoryItem.restaurant_id == user.restaurant_id,
            InventoryItem.is_active == True,
            InventoryItem.category != None,
        ).distinct()
    )
    cats = [row[0] for row in result.all() if row[0]]
    return sorted(cats)
