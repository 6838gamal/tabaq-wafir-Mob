from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from typing import List, Optional

from app.core.database import get_db
from app.core.deps import get_current_admin_user
from app.models.user import User
from app.models.restaurant import Restaurant

router = APIRouter()


@router.get("/restaurants")
async def list_all_restaurants(
    status: Optional[str] = None,
    search: Optional[str] = None,
    skip: int = 0,
    limit: int = 50,
    admin: User = Depends(get_current_admin_user),
    db: AsyncSession = Depends(get_db),
):
    q = select(Restaurant)
    if status:
        q = q.where(Restaurant.status == status)
    if search:
        q = q.where(Restaurant.name.ilike(f"%{search}%"))
    q = q.offset(skip).limit(limit).order_by(Restaurant.created_at.desc())

    result = await db.execute(q)
    restaurants = result.scalars().all()
    return [
        {
            "id": r.id,
            "name": r.name,
            "status": r.status,
            "commission_rate": float(r.commission_rate),
            "city": r.city,
            "created_at": r.created_at.isoformat(),
        }
        for r in restaurants
    ]


@router.patch("/restaurants/{restaurant_id}/status")
async def update_restaurant_status(
    restaurant_id: str,
    status: str,
    admin: User = Depends(get_current_admin_user),
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(Restaurant).where(Restaurant.id == restaurant_id))
    r = result.scalar_one_or_none()
    if not r:
        raise HTTPException(404, "Restaurant not found")
    if status not in ("active", "suspended", "pending"):
        raise HTTPException(400, "Invalid status")
    r.status = status
    db.add(r)
    return {"id": r.id, "status": r.status}


@router.get("/stats")
async def platform_stats(
    admin: User = Depends(get_current_admin_user),
    db: AsyncSession = Depends(get_db),
):
    total_restaurants = await db.execute(select(func.count(Restaurant.id)))
    active_restaurants = await db.execute(select(func.count(Restaurant.id)).where(Restaurant.status == "active"))
    total_users = await db.execute(select(func.count(User.id)))

    return {
        "total_restaurants": int(total_restaurants.scalar() or 0),
        "active_restaurants": int(active_restaurants.scalar() or 0),
        "total_users": int(total_users.scalar() or 0),
    }
