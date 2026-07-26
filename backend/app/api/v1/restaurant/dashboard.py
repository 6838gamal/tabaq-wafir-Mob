from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from datetime import datetime, timezone, timedelta

from app.core.database import get_db
from app.core.deps import get_current_restaurant_user
from app.models.user import User
from app.models.inventory import InventoryItem
from app.models.order import Order

router = APIRouter()


@router.get("")
async def get_dashboard(
    user: User = Depends(get_current_restaurant_user),
    db: AsyncSession = Depends(get_db),
):
    rid = user.restaurant_id or "demo"
    today = datetime.now(timezone.utc).replace(hour=0, minute=0, second=0, microsecond=0)

    # Today orders
    orders_res = await db.execute(
        select(func.count(Order.id), func.sum(Order.total))
        .where(Order.restaurant_id == rid, Order.created_at >= today)
    )
    order_row = orders_res.one()
    today_orders = int(order_row[0] or 0)
    today_revenue = float(order_row[1] or 0)

    # Inventory alerts
    inv_res = await db.execute(
        select(func.count(InventoryItem.id)).where(
            InventoryItem.restaurant_id == rid,
            InventoryItem.is_active == True,
            InventoryItem.current_stock <= InventoryItem.min_stock,
        )
    )
    low_stock = int(inv_res.scalar() or 0)

    out_res = await db.execute(
        select(func.count(InventoryItem.id)).where(
            InventoryItem.restaurant_id == rid,
            InventoryItem.is_active == True,
            InventoryItem.current_stock <= 0,
        )
    )
    out_stock = int(out_res.scalar() or 0)

    return {
        "today": {
            "orders": today_orders,
            "revenue": round(today_revenue, 2),
            "avg_order_value": round(today_revenue / today_orders, 2) if today_orders else 0,
        },
        "inventory": {
            "low_stock_count": low_stock,
            "out_of_stock_count": out_stock,
        },
        "generated_at": datetime.now(timezone.utc).isoformat(),
    }
