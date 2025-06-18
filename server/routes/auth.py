import uuid
import bcrypt
from fastapi import Depends, HTTPException
from requests import Session
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from database import get_db
from pydantic_schemas.user_login import UserLogin
from pydantic_schemas.user_response import UserResponse
import jwt
from middleware.auth_middleware import auth_middleware
from sqlalchemy.orm import joinedload

router = APIRouter()

@router.post('/signup', response_model=UserResponse, status_code=201)
def signup_user(user: UserCreate, db: Session=Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()
    if user_db:
        raise HTTPException(400, 'User with the same email already exists!')
    hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    user_db = User(id=str(uuid.uuid4()), email=user.email, password=hashed_pw, name=user.name)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return user_db

@router.post('/login')
def login_user(user: UserLogin, db: Session = Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()
    if not user_db:
        raise HTTPException(400, 'User with this email does not exist!')
    
    is_match = bcrypt.checkpw(user.password.encode(), bytes(user_db.password))
    if not is_match:
        raise HTTPException(400, 'Incorrect password!')
    
    token = jwt.encode({'id': user_db.id}, 'loyalty', algorithm='HS256')
    
    user_response = UserResponse.model_validate(user_db)
    return {
        'token': token,
        'user': user_response
    }

@router.get('/',response_model=UserResponse)
def current_user_data(db: Session=Depends(get_db), 
                      user_dict = Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).options(
        joinedload(User.favorites)
    ).first()

    if not user:
        raise HTTPException(404, 'User not found!')
    
    return user

