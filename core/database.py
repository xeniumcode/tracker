from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from core.config import settings
from models.client import Base

engine = create_engine(settings.DATABASE_URL, echo=settings.DATABASE_LOG)
Base.metadata.create_all(bind=engine)
SessionLocal = sessionmaker(bind=engine, expire_on_commit=False)
