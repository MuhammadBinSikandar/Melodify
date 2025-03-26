from fastapi import FastAPI
from routes import auth
from models.base import Base
from database import engine
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()
app.include_router(auth.router, prefix='/auth')

Base.metadata.create_all(engine) 