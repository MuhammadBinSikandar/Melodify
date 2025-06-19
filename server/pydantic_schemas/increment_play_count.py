from pydantic import BaseModel

class IncrementPlayCount(BaseModel):
    song_id: str