from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime


class GoogleLoginRequest(BaseModel):
    id_token: str
    app_type: str = "restaurant"  # restaurant, customer, driver


class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    user: "UserOut"


class RefreshRequest(BaseModel):
    refresh_token: str


class UserOut(BaseModel):
    id: str
    name: str
    email: Optional[str] = None
    avatar_url: Optional[str] = None
    role: str
    restaurant_id: Optional[str] = None
    locale: str = "ar"
    created_at: datetime

    model_config = {"from_attributes": True}


class UpdateProfileRequest(BaseModel):
    name: Optional[str] = None
    phone: Optional[str] = None
    locale: Optional[str] = None
    fcm_token: Optional[str] = None
