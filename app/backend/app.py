from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine, text
from pydantic import BaseModel
import os

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    # should be frontend domain
    # domain wasn't purchased for that and we are using cloudfront default domain
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database connection string
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASS = os.getenv("DB_PASS", "password")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME", "testdb")

DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:5432/{DB_NAME}"
engine = create_engine(DATABASE_URL, echo=True, future=True)

class Message(BaseModel):
    content: str

@app.post("/api/put-into-db")
async def put_into_db(message: Message):
    try:
        with engine.begin() as conn:
            conn.execute(
                text("INSERT INTO messages (content) VALUES (:content)"),
                {"content": message.content}
            )
        return {"status": "success"}
    except Exception as e:
        return {"status": "error", "details": str(e)}
