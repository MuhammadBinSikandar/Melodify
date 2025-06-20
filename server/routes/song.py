# server/routes/song.py
import uuid
import cloudinary
import cloudinary.uploader
from fastapi import APIRouter, HTTPException, UploadFile, File, Form, Depends
from sqlalchemy.orm import Session
from database import get_db
from middleware.auth_middleware import auth_middleware
from models.song import Song
from pydantic_schemas.favotite_song import FavoriteSong
from models.favorite import Favorite
from sqlalchemy.orm import joinedload

from pydantic_schemas.increment_play_count import IncrementPlayCount

router = APIRouter()



cloudinary.config( 
    cloud_name = "ddudykruo", 
    api_key = "331346271764311", 
    api_secret = "n_8A5GzgoYV3VjJkKBO__0fcPcY", # Click 'View API Keys' above to copy your API secret
    secure=True
)

@router.post('/upload', status_code=201)
def upload_song(song: UploadFile= File(...), 
                thumbnail: UploadFile=File(...), 
                artist: str=Form(...), 
                song_name: str=Form(...), 
                hex_code: str=Form(...),
                db: Session= Depends(get_db),
                auth_dict= Depends(auth_middleware)):
    song_id= str(uuid.uuid4())
    song_res = cloudinary.uploader.upload(song.file, resource_type='auto', folder=f'songs/{song_id}')
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type='image', folder=f'songs/{song_id}')
    new_song = Song(
        id=song_id, 
        song_name=song_name,
        artist=artist,
        hex_code=hex_code,
        song_url=song_res['url'],
        thumbnail_url=thumbnail_res['url']
    )
    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song


@router.get('/list')
def list_songs(db: Session = Depends(get_db), auth_details= Depends(auth_middleware)):
    songs = db.query(Song).all()
    return songs    

@router.post('/favorite')
def favorite_song(song: FavoriteSong, 
                  db: Session=Depends(get_db), 
                  auth_details=Depends(auth_middleware)):
    # song is already favorited by the user
    user_id = auth_details['uid']

    fav_song = db.query(Favorite).filter(Favorite.song_id == song.song_id, Favorite.user_id == user_id).first()

    if fav_song:
        db.delete(fav_song)
        db.commit()
        return {'message': False}
    else:
        new_fav = Favorite(id=str(uuid.uuid4()), song_id=song.song_id, user_id=user_id)
        db.add(new_fav)
        db.commit()
        return {'message': True}
    

@router.get('/list/favorites')
def list_fav_songs(db: Session=Depends(get_db), 
               auth_details=Depends(auth_middleware)):
    user_id = auth_details['uid']
    fav_songs = db.query(Favorite).filter(Favorite.user_id == user_id).options(
        joinedload(Favorite.song),
    ).all()
    
    return fav_songs

@router.post('/increment-play-count')
def increment_play_count(request: IncrementPlayCount,
                        db: Session = Depends(get_db), 
                        auth_details= Depends(auth_middleware)):
    song = db.query(Song).filter(Song.id == request.song_id).first()
    if not song:
        raise HTTPException(status_code=404, detail="Song not found")
    
    song.play_count += 1
    db.commit()
    db.refresh(song)
    return {"message": "Play count incremented", "play_count": song.play_count}

@router.get('/top-songs')
def get_top_songs(db: Session = Depends(get_db), 
                 auth_details= Depends(auth_middleware)):
    top_songs = db.query(Song).order_by(Song.play_count.desc()).limit(20).all()
    return top_songs