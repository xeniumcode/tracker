from pydantic import BaseModel


class TokenRequest(BaseModel):
    deviceId: str
