from time import time
from typing import Optional
from pydantic import BaseModel


class LocationData(BaseModel):
    latitude: float
    longitude: float
    timestamp: Optional[int] = int(time() * 1000)
