from sqlalchemy.orm import Session
from dao.client import DeviceDAO, LocationDAO
from schemas.location import LocationData


def save_location(db: Session, deviceId: str, location: LocationData):
    location_dao = LocationDAO(session=db)
    return location_dao.create(
        deviceId=deviceId,
        longitude=location.longitude,
        latitude=location.latitude,
        timestamp=location.timestamp,
    )

def check_device(db:Session,deviceId:str):
    device_dao = DeviceDAO(session=db)
    device = device_dao.get_by_deviceId(deviceId)
    if not device:
        device = device_dao.create(deviceId)