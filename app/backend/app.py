from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine, text
import os

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    # should be frontend domain which is not the purpose of this project
    # project is about infrastructure not development
    # domain wasn't purchased for that and we are using cloudfront default domain
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database connection string (use ECS env vars)
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASS = os.getenv("DB_PASS", "password")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME", "testdb")

DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:5432/{DB_NAME}"
engine = create_engine(DATABASE_URL, echo=True, future=True)

@app.get("/api/put-into-db")
async def put_into_db():
    try:
        with engine.begin() as conn:
            conn.execute(
                text("INSERT INTO messages (content) VALUES (:content)"),
                {"content": "Hello from FastAPI on ECS!"}
            )
        return {"status": "success"}
    except Exception as e:
        return {"status": "error", "details": str(e)}
