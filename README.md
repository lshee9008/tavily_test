## 깃허브 링크
>https://github.com/lshee9008/tavily_test

## "Beyond Training Data" - 실시간 웹 지식 기반 AI 검색 엔진

LLM의 고질적인 한계인 지식 컷오프(Knowledge Cut-off)와 할루시네이션(Hallucination)을 극복하기 위해, **Tavily API**와 **FastAPI**를 결합한 RAG(검색 증강 생성) 기반의 지능형 검색 플랫폼입니다.

단순한 키워드 검색을 넘어, AI가 실시간 웹 데이터를 직접 서칭하고 신뢰할 수 있는 출처와 함께 요약된 답변을 제공합니다. 사용자 경험을 극대화하기 위해 **Glassmorphism UI**와 **Elastic Interaction**을 적용하여 시각적 완성도를 높였습니다.

## 실행 화면
![](https://velog.velcdn.com/images/fpalzntm/post/5e57c803-13e9-4839-97ec-e517d76c9e64/image.png)


## 아키텍처
![](https://velog.velcdn.com/images/fpalzntm/post/9301ed97-346a-4c31-b0fd-cf341851bda9/image.png)


## 주요 기능

| 기능 | 설명 |
| --- | --- |
| **AI 요약 답변** | Tavily API가 여러 웹 소스를 종합하여 질문에 대한 문장형 답변 직접 생성 |
| **실시간 출처 제공** | 검색 결과의 제목, 내용 요약, 실제 URL을 카드 형태로 매칭하여 신뢰성 확보 |
| **Glassmorphism UI** | BackdropFilter와 Blur 효과를 이용한 현대적이고 세련된 유리 질감 디자인 |
| **Elastic 인터랙션** | Curves.elasticOut을 활용하여 결과 리스트가 통통 튀듯 등장하는 물리 기반 애니메이션 |
| **Hero 트랜지션** | 홈 화면의 검색바가 결과 화면의 헤더로 매끄럽게 확장되는 화면 전환 효과 |
| **Haptic Feedback** | 검색 및 결과 도출 시 미세한 진동 피드백을 통해 UX 완성도 향상 |

## 기술 스택

| 영역 | 기술 | 상세 |
| --- | --- | --- |
| **Frontend** | Flutter, Dart | Glassmorphism, Hero/Elastic Animation, url_launcher |
| **Backend** | Python, FastAPI | Asynchronous Routing, Pydantic, CORS Middleware |
| **AI Search** | Tavily API | AI-Optimized Search & Content Extraction |
| **DevOps** | Docker, .env | Environment Variable Management, Containerization |

---

## Tavily API란?

본 프로젝트의 엔진인 **Tavily**는 일반 검색 엔진(Google, Bing)과 달리 **LLM 및 AI 에이전트만을 위해 설계된 검색 서비스**입니다.

1. **AI 최적화 컨텍스트:** 검색 결과에서 불필요한 광고, 스크립트, HTML 태그를 모두 제거하고 AI가 바로 이해할 수 있는 깨끗한 텍스트 데이터(Clean Text)만 반환합니다.
2. **RAG 전용 알고리즘:** 단순히 키워드가 많이 포함된 순서가 아니라, AI가 답변을 생성하는 데 가장 도움이 되는 정보(Context)를 우선순위로 정렬하여 제공합니다.
3. **검색 증강 생성(RAG):** 별도의 LLM 튜닝 없이도 `include_answer` 옵션을 통해 검색 결과에 기반한 고품질 요약 답변을 얻을 수 있어 환각 현상을 현저히 줄여줍니다.

---

## 디렉토리 구조

```text
tavily-ai-search/
├── flutter_app/             # Flutter 프론트엔드 (Glassmorphism UI)
│   ├── lib/
│   │   ├── main.dart        # 메인 UI 및 애니메이션 로직
│   │   ├── services/        # API 통신 및 데이터 처리
│   │   └── widgets/         # GlassBox, ResultCard 등 공통 컴포넌트
│   └── pubspec.yaml         # http, url_launcher 등 패키지 관리
│
├── fastapi_backend/         # FastAPI 서버 (Proxy & Logic)
│   ├── main.py              # 엔트리 포인트 및 CORS 설정
│   ├── schemas.py           # Pydantic 데이터 모델 (Request/Response)
│   ├── services.py          # Tavily Client 비즈니스 로직
│   ├── .env                 # API Key 관리 (TAVILY_API_KEY)
│   └── requirements.txt
│
└── docs/                    # 프로젝트 관련 문서
    └── architecture.md      # 상세 시스템 설계도

```

## 해결 전략 및 문제 해결 (Troubleshooting)

* **애니메이션 크래시 해결:** `Curves.elasticOut` 적용 시 반동 효과로 인해 `Opacity` 값이 1.0을 초과하여 `AssertionError`가 발생하는 문제를 `.clamp(0.0, 1.0)` 메서드를 통해 수치 범위를 강제 제한하여 해결했습니다.
* **보안 아키텍처 수립:** API Key가 클라이언트(Flutter) 측에 노출되는 것을 방지하기 위해, FastAPI를 미들웨어 서버로 구축하여 백엔드 서버 측에서만 API Key를 관리하도록 설계했습니다.
* **네트워크 데이터 정제:** 웹 검색 결과의 한글 깨짐 현상을 방지하기 위해 `utf8.decode(response.bodyBytes)`를 적용하여 데이터의 무결성을 확보했습니다.

## 실행 방법

### 1. Backend 설정

```bash
cd fastapi_backend
pip install -r requirements.txt
# .env 파일 생성 후 TAVILY_API_KEY 입력
python main.py

```

### 2. Frontend 설정

```bash
cd flutter_app
flutter pub get
flutter run

```

---
