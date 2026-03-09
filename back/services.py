import os
from tavily import TavilyClient
from dotenv import load_dotenv

load_dotenv()

class TavilyService:
    def __init__(self):
        api_key = os.getenv("TAVILY_API_KEY")
        self.client = TavilyClient(api_key=api_key)

    def search_sync(self, query: str):
        # AI 에이전트 최적화 검색 수행
        return self.client.search(
            query=query,
            search_depth="advanced",
            include_answer=True,
            max_results=5
        )

tavily_service = TavilyService()