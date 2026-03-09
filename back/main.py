from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from schemas import SearchRequest, SearchResponse
from services import tavily_service
import uvicorn

app = FastAPI(title="Pro AI Search Service")

# CORS 설정 (Flutter 연동 필수)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/api/v1/search", response_model=SearchResponse)
async def ai_search(payload: SearchRequest):
    try:
        # Tavily 서비스 호출
        results = tavily_service.search_sync(payload.query)
        return results
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)