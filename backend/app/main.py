from fastapi import FastAPI
from sqlalchemy import text
from statistics import median
import random
import os

from app.database import SessionLocal

app = FastAPI()

VERSION = os.getenv("APP_VERSION", "1.0.0")


@app.get("/health")
def health():
    return {"status": "UP"}


@app.get("/version")
def version():
    return {"version": VERSION}


@app.get("/dice-types")
def dice_types():

    db = SessionLocal()

    rows = db.execute(
        text(
            """
            SELECT id,name,sides
            FROM dice_types
            ORDER BY sides
            """
        )
    ).fetchall()

    db.close()

    return [
        {
            "id": r.id,
            "name": r.name,
            "sides": r.sides
        }
        for r in rows
    ]


@app.post("/roll")
def roll(data: dict):

    dice_id = data["dice_id"]
    count = data["count"]

    db = SessionLocal()

    row = db.execute(
        text(
            """
            SELECT name,sides
            FROM dice_types
            WHERE id=:id
            """
        ),
        {"id": dice_id}
    ).fetchone()

    db.close()

    results = [
        random.randint(1, row.sides)
        for _ in range(count)
    ]

    return {
        "dice": row.name,
        "results": results,
        "average": round(sum(results) / len(results), 2),
        "min": min(results),
        "max": max(results),
        "median": median(results)
    }