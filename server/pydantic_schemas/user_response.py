from pydantic import BaseModel
from typing import List, Optional

# class UserResponse(BaseModel):
#     id: str
#     email: str
#     name: str

#     class Config:
#         from_attributes = True

class FavoriteResponse(BaseModel):
    id: str
    song_id: str
    user_id: str
    # Add other favorite fields as needed
    
    class Config:
        from_attributes = True

class UserResponse(BaseModel):
    id: str
    name: str
    email: str
    # Add other user fields you want to return
    favorites: List[FavoriteResponse] = []
    
    class Config:
        from_attributes = True