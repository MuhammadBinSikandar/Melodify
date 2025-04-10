from fastapi import FastAPI
from routes import auth
from models.base import Base
from database import engine
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # replace * with frontend origin in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(auth.router, prefix='/auth')

Base.metadata.create_all(engine) 