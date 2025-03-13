import uuid
import bcrypt
from fastapi import HTTPException
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from database import db

router = APIRouter()

@router.post('/signup')
def signup(user: UserCreate):
    user_db = db.query(User).filter(User.email == user.email).first() # check if user already exists
    if user_db:
        raise HTTPException(status_code=400, detail='User already exists')
    hashed_pw = bcrypt.hashpw(user.password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
    user_db = User(id=str(uuid.uuid4()), name=user.name, email=user.email, password=hashed_pw)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return {"id": user_db.id, "name": user_db.name, "email": user_db.email}