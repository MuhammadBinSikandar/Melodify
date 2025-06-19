# server/models/song.py
from sqlalchemy import VARCHAR, TEXT, Column, Integer
from models.base import Base

class Song(Base):
    __tablename__ = 'songs'

    id = Column(TEXT, primary_key=True)
    song_url = Column(TEXT, nullable=False)
    thumbnail_url = Column(TEXT, nullable=False)
    artist = Column(TEXT)
    song_name = Column(VARCHAR(100))
    hex_code = Column(VARCHAR(6))
    play_count = Column(Integer, default=0)