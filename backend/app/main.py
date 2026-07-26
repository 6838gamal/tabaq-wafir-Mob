from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from .catalog import APPS, ROLE_FEATURES, features_for

app = FastAPI(
    title="Restaurant Ecosystem Platform API",
    version="1.0.0",
    openapi_url="/v1/openapi.json",
    docs_url="/docs",
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


class AccessResponse(BaseModel):
    app: str
    role: str
    features: list[str]


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok", "service": "restaurant-ecosystem-api"}


@app.get("/v1/platform/apps")
def platform_apps() -> dict[str, list[str]]:
    return {"apps": list(APPS)}


@app.get("/v1/platform/features")
def platform_features() -> dict[str, dict[str, list[str]]]:
    return ROLE_FEATURES


@app.get("/v1/access/{app_name}/{role}", response_model=AccessResponse)
def role_access(app_name: str, role: str) -> AccessResponse:
    if app_name not in APPS:
        raise HTTPException(status_code=404, detail="Unknown application")
    if role not in ROLE_FEATURES.get(app_name, {}):
        raise HTTPException(status_code=404, detail="Unknown role for application")
    return AccessResponse(app=app_name, role=role, features=features_for(app_name, role))