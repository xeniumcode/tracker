from fastapi import FastAPI
from core.initializer import AppInitializer

app = FastAPI(
    title="Tracker Service",
    summary="Tracker Service",
    description="Service to save  user info and provide authentication for admin frontend.",
    docs_url="/",
    contact={
        "name": "Aman Poonia",
        "url": "https://amanpoonia.in",
        "email": "contact@amanpoonia.in",
    },
)

AppInitializer(app).setup()
