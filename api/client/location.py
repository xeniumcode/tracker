from typing import Annotated
from fastapi import APIRouter, Depends
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from core.exceptions import (
    AccessTokenMissingException,
    InvalidTokenException,
    InvalidTokenPayloadException,
)
from schemas.location import LocationData
from services.location import save_location
from utils.jwt_helpers import decode_access_token
from dependencies.dao_dep import SessionDep

router = APIRouter()
security = HTTPBearer()


@router.post("/location")
async def location(
    location: LocationData,
    credentials: Annotated[HTTPAuthorizationCredentials, Depends(security)],
    db: SessionDep,
):
    token = credentials.credentials
    if not token:
        raise AccessTokenMissingException()
    try:
        payload = decode_access_token(token)
        deviceId: str | None = payload.get("sub")
        if deviceId is None:
            raise InvalidTokenPayloadException()
    except Exception:
        raise InvalidTokenException()
    save_location(db, location=location, deviceId=deviceId)
    return {"detail": "Success"}
