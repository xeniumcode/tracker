from typing import Annotated
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from models.android_device import LocationData, TokenRequest
from utils.jwt_helpers import create_access_token, decode_access_token

router = APIRouter()
security = HTTPBearer()


@router.post("/location")
async def location(
    location: LocationData,
    credentials: Annotated[HTTPAuthorizationCredentials, Depends(security)],
):
    token = credentials.credentials
    try:
        payload = decode_access_token(token)
        # save data
        return {"status": "OK"}
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )


@router.post("/get-token")
async def get_token(request: TokenRequest):
    device_id = request.userId
    token = create_access_token(device_id)
    return {"token": token}
