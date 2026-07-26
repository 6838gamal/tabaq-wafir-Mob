from fastapi import APIRouter
from app.api.v1.auth import router as auth_router
from app.api.v1.restaurant import inventory, suppliers, purchases, recipes, dashboard, transfers
from app.api.v1.admin import restaurants as admin_router

api_router = APIRouter()

api_router.include_router(auth_router, prefix="/auth", tags=["Authentication"])
api_router.include_router(dashboard.router, prefix="/restaurant/dashboard", tags=["Restaurant - Dashboard"])
api_router.include_router(inventory.router, prefix="/restaurant/inventory", tags=["Restaurant - Inventory"])
api_router.include_router(suppliers.router, prefix="/restaurant/suppliers", tags=["Restaurant - Suppliers"])
api_router.include_router(purchases.router, prefix="/restaurant/purchases", tags=["Restaurant - Purchases"])
api_router.include_router(recipes.router, prefix="/restaurant/recipes", tags=["Restaurant - Recipes"])
api_router.include_router(transfers.router, prefix="/restaurant/transfers", tags=["Restaurant - Transfers"])
api_router.include_router(admin_router.router, prefix="/admin", tags=["Admin"])
