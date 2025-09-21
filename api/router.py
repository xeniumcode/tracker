from api.client.auth import router as auth_router
from api.client.location import router as location_router
from fastapi import APIRouter

router = APIRouter()

router.include_router(auth_router)
router.include_router(location_router)
