from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import boto3

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    # should be frontend domain which is not the purpose of this project
    # project is about infrastructure not development
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/api/do-something")
async def do_something():
    try:
        rds = boto3.client("rds")
        rds.describe_db_instances()
    except Exception as e:
        return {"status": "error", "details": str(e)}

    return {"status": "success"}
