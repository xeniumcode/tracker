from fastapi import APIRouter
from schemas.auth import TokenRequest
from services.location import check_device
from utils.jwt_helpers import create_access_token
from dependencies.dao_dep import SessionDep

router = APIRouter()


@router.post("/get-token")
async def get_token(request: TokenRequest, db: SessionDep):
    deviceId = request.deviceId
    check_device(db,deviceId=deviceId)
    token = create_access_token(deviceId)
    return {"token": token}
