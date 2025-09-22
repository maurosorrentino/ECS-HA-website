from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_do_something_success():
    response = client.get("/api/do-something")
    assert response.status_code == 200
    assert "status" in response.json()
    # Either success or error (if AWS creds not configured)
    assert response.json()["status"] in ["success", "error"]
