from typing import Optional
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.core.database import get_db
from app.core.security import decode_token
from app.core.permissions import UserRole, Permission, has_permission
from app.models.user import User

security = HTTPBearer(auto_error=False)


async def get_current_user(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(security),
    db: AsyncSession = Depends(get_db),
) -> User:
    if not credentials:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Not authenticated")

    payload = decode_token(credentials.credentials)
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")

    result = await db.execute(select(User).where(User.id == user_id, User.is_active == True))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found")

    return user


async def get_current_restaurant_user(user: User = Depends(get_current_user)) -> User:
    restaurant_roles = {
        UserRole.RESTAURANT_OWNER, UserRole.GENERAL_MANAGER, UserRole.BRANCH_MANAGER,
        UserRole.SUPERVISOR, UserRole.CASHIER, UserRole.KITCHEN,
        UserRole.WAITER, UserRole.INVENTORY_MANAGER, UserRole.ACCOUNTANT,
    }
    if UserRole(user.role) not in restaurant_roles:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Access denied")
    return user


async def get_current_admin_user(user: User = Depends(get_current_user)) -> User:
    admin_roles = {UserRole.PLATFORM_OWNER, UserRole.PLATFORM_ADMIN, UserRole.FINANCE, UserRole.SUPPORT}
    if UserRole(user.role) not in admin_roles:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Admin access required")
    return user


async def get_current_driver(user: User = Depends(get_current_user)) -> User:
    if user.role != UserRole.DRIVER.value:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Driver access only")
    return user


def require_permission(permission: Permission):
    async def checker(user: User = Depends(get_current_restaurant_user)):
        if not has_permission(UserRole(user.role), permission):
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail=f"Missing permission: {permission}")
        return user
    return checker
