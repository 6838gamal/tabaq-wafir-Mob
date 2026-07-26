from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from datetime import datetime, timezone

from app.core.database import get_db
from app.core.security import verify_google_token, create_access_token, create_refresh_token, decode_token
from app.core.deps import get_current_user
from app.models.user import User
from app.schemas.auth import GoogleLoginRequest, TokenResponse, UserOut, RefreshRequest, UpdateProfileRequest

router = APIRouter()


@router.post("/google", response_model=TokenResponse, summary="Sign in with Google")
async def google_login(body: GoogleLoginRequest, db: AsyncSession = Depends(get_db)):
    google_info = await verify_google_token(body.id_token)
    if not google_info:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid Google token")

    # Find or create user
    result = await db.execute(select(User).where(User.google_id == google_info["google_id"]))
    user = result.scalar_one_or_none()

    # Determine default role by app_type
    default_role_map = {
        "restaurant": "restaurant_owner",
        "customer": "customer",
        "driver": "driver",
    }
    default_role = default_role_map.get(body.app_type, "restaurant_owner")

    if not user:
        user = User(
            google_id=google_info["google_id"],
            name=google_info.get("name", "User"),
            email=google_info.get("email"),
            avatar_url=google_info.get("picture"),
            role=default_role,
            created_at=datetime.now(timezone.utc),
        )
        db.add(user)
        await db.flush()
        await db.refresh(user)

    if not user.is_active:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Account suspended")

    # Build token payload
    token_data = {
        "sub": user.id,
        "role": user.role,
        "restaurant_id": user.restaurant_id,
    }
    access_token = create_access_token(token_data)
    refresh_token = create_refresh_token({"sub": user.id})

    return TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token,
        user=UserOut.model_validate(user),
    )


@router.post("/refresh", response_model=TokenResponse, summary="Refresh access token")
async def refresh_token(body: RefreshRequest, db: AsyncSession = Depends(get_db)):
    payload = decode_token(body.refresh_token)
    if not payload or payload.get("type") != "refresh":
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid refresh token")

    result = await db.execute(select(User).where(User.id == payload["sub"], User.is_active == True))
    user = result.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="User not found")

    token_data = {"sub": user.id, "role": user.role, "restaurant_id": user.restaurant_id}
    return TokenResponse(
        access_token=create_access_token(token_data),
        refresh_token=create_refresh_token({"sub": user.id}),
        user=UserOut.model_validate(user),
    )


@router.get("/me", response_model=UserOut, summary="Get current user")
async def get_me(user: User = Depends(get_current_user)):
    return UserOut.model_validate(user)


@router.put("/me", response_model=UserOut, summary="Update profile")
async def update_me(body: UpdateProfileRequest, user: User = Depends(get_current_user), db: AsyncSession = Depends(get_db)):
    if body.name:
        user.name = body.name
    if body.phone:
        user.phone = body.phone
    if body.locale:
        user.locale = body.locale
    if body.fcm_token and body.fcm_token not in (user.fcm_tokens or []):
        user.fcm_tokens = (user.fcm_tokens or []) + [body.fcm_token]
    user.updated_at = datetime.now(timezone.utc)
    db.add(user)
    return UserOut.model_validate(user)


@router.post("/logout", summary="Logout")
async def logout(user: User = Depends(get_current_user)):
    # In production: blacklist token in Redis
    return {"message": "Logged out successfully"}
