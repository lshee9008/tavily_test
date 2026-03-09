from pydantic import BaseModel
from typing import List, Optional

class SearchRequest(BaseModel):
    query: str

class SearchResult(BaseModel):
    title: str
    url: str
    content: str
    score: float

class SearchResponse(BaseModel):
    answer: Optional[str] = None
    results: List[SearchResult]