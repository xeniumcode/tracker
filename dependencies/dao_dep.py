from typing import Annotated
from fastapi import Depends
from sqlalchemy.orm import Session
from core.database import SessionLocal

def get_session():
   with SessionLocal() as session:
        yield session
SessionDep = Annotated[Session, Depends(get_session)]