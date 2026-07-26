from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from typing import List, Optional
from datetime import datetime, timezone

from app.core.database import get_db
from app.core.deps import get_current_restaurant_user
from app.models.user import User
from app.models.inventory import Supplier, Purchase
from app.schemas.inventory import SupplierCreate, SupplierUpdate, SupplierOut

router = APIRouter()


@router.get("", response_model=List[SupplierOut])
async def list_suppliers(
    search: Optional[str] = None,
    category: Optional[str] = None,
    is_active: bool = True,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    q = select(Supplier).where(Supplier.restaurant_id == user.restaurant_id, Supplier.is_active == is_active)
    if search:
        q = q.where(Supplier.name.ilike(f"%{search}%"))
    if category:
        q = q.where(Supplier.category == category)
    q = q.order_by(Supplier.name)

    result = await db.execute(q)
    suppliers = result.scalars().all()

    outs = []
    for s in suppliers:
        # Get total purchases & last purchase date
        stats = await db.execute(
            select(func.sum(Purchase.total_amount), func.max(Purchase.created_at))
            .where(Purchase.supplier_id == s.id)
        )
        row = stats.one()
        out = SupplierOut.model_validate(s)
        out.total_purchases = float(row[0] or 0)
        out.last_purchase_date = row[1].date() if row[1] else None
        outs.append(out)
    return outs


@router.post("", response_model=SupplierOut, status_code=201)
async def create_supplier(
    body: SupplierCreate,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    supplier = Supplier(**body.model_dump(), restaurant_id=user.restaurant_id)
    db.add(supplier)
    await db.flush()
    await db.refresh(supplier)
    return SupplierOut.model_validate(supplier)


@router.get("/{supplier_id}", response_model=SupplierOut)
async def get_supplier(
    supplier_id: str,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Supplier).where(Supplier.id == supplier_id, Supplier.restaurant_id == user.restaurant_id)
    )
    s = result.scalar_one_or_none()
    if not s:
        raise HTTPException(404, "Supplier not found")
    return SupplierOut.model_validate(s)


@router.put("/{supplier_id}", response_model=SupplierOut)
async def update_supplier(
    supplier_id: str,
    body: SupplierUpdate,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Supplier).where(Supplier.id == supplier_id, Supplier.restaurant_id == user.restaurant_id)
    )
    s = result.scalar_one_or_none()
    if not s:
        raise HTTPException(404, "Supplier not found")
    for field, value in body.model_dump(exclude_none=True).items():
        setattr(s, field, value)
    db.add(s)
    return SupplierOut.model_validate(s)


@router.delete("/{supplier_id}", status_code=204)
async def delete_supplier(
    supplier_id: str,
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Supplier).where(Supplier.id == supplier_id, Supplier.restaurant_id == user.restaurant_id)
    )
    s = result.scalar_one_or_none()
    if not s:
        raise HTTPException(404, "Supplier not found")
    s.is_active = False
    db.add(s)
