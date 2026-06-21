from unittest.mock import MagicMock, patch

from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_health_returns_up():
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "UP"}


def test_version_returns_version():
    response = client.get("/version")

    assert response.status_code == 200
    assert "version" in response.json()
    assert response.json()["version"] == "1.0.0"


@patch("app.main.SessionLocal")
def test_dice_types_returns_list(mock_session_local):
    mock_db = MagicMock()

    mock_db.execute.return_value.fetchall.return_value = [
        MagicMock(id=1, name="K6", sides=6),
        MagicMock(id=2, name="K10", sides=10),
    ]

    mock_session_local.return_value = mock_db

    response = client.get("/dice-types")

    assert response.status_code == 200
    assert response.json() == [
        {"id": 1, "name": "K6", "sides": 6},
        {"id": 2, "name": "K10", "sides": 10},
    ]

    mock_db.close.assert_called_once()


@patch("app.main.SessionLocal")
def test_roll_returns_statistics(mock_session_local):
    mock_db = MagicMock()

    mock_db.execute.return_value.fetchone.return_value = MagicMock(
        name="K6",
        sides=6
    )

    mock_session_local.return_value = mock_db

    response = client.post(
        "/roll",
        json={
            "dice_id": 1,
            "count": 3
        }
    )

    assert response.status_code == 200

    data = response.json()

    assert data["dice"] == "K6"
    assert len(data["results"]) == 3
    assert all(1 <= result <= 6 for result in data["results"])

    assert "average" in data
    assert "min" in data
    assert "max" in data
    assert "median" in data

    assert data["min"] == min(data["results"])
    assert data["max"] == max(data["results"])
    assert mock_db.close.called