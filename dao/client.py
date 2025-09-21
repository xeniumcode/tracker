from typing import List, Optional
from sqlalchemy.orm import Session
from models.client import Device, Location  

class DeviceDAO:
    def __init__(self, session: Session, model=Device):
        self.session = session
        self.model = model

    def create(self, deviceId: str) -> Device:
        device = self.model(deviceId=deviceId)
        self.session.add(device)
        self.session.commit()
        return device

    def get_by_deviceId(self, deviceId: str) -> Optional[Device]:
        return self.session.query(self.model).filter(self.model.deviceId == deviceId).first()


class LocationDAO:
    def __init__(self, session: Session, model=Location):
        self.session = session
        self.model = model

    def create(self, deviceId: int, latitude: float, longitude: float, timestamp: Optional[int] = None) -> Location:
        location = self.model(
            deviceId=deviceId,
            latitude=latitude,
            longitude=longitude,
            timestamp=timestamp)
        self.session.add(location)
        self.session.commit()
        return location

    def get_latest_by_device(self, deviceId: int) -> Optional[Location]:
        return (
            self.session.query(self.model)
            .filter(self.model.deviceId == deviceId)
            .order_by(self.model.timestamp.desc())
            .first())

    def list_by_device(self, deviceId: int, limit: int = 100) -> List[Location]:
        return (
            self.session.query(self.model)
            .filter(self.model.deviceId == deviceId)
            .order_by(self.model.timestamp.desc())
            .limit(limit)
            .all()
        )