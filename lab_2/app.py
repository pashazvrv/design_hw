import os

import psycopg2
from flask import Flask

app = Flask(__name__)


@app.get("/health")
def health():
    return "ok\n"


@app.get("/")
def index():
    try:
        conn = psycopg2.connect(
            host=os.environ.get("DB_HOST", "db"),
            dbname=os.environ.get("POSTGRES_DB", "appdb"),
            user=os.environ.get("POSTGRES_USER", "appuser"),
            password=os.environ.get("POSTGRES_PASSWORD", ""),
            connect_timeout=3,
        )
        with conn, conn.cursor() as cur:
            cur.execute("CREATE TABLE IF NOT EXISTS visits (id SERIAL PRIMARY KEY)")
            cur.execute("INSERT INTO visits DEFAULT VALUES")
            cur.execute("SELECT count(*) FROM visits")
            return f"Visits: {cur.fetchone()[0]}\n"
    except psycopg2.Error as e:
        return f"No database: {e}\n", 503
