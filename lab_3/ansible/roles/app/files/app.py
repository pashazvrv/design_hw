import socket

from flask import Flask

app = Flask(__name__)
visits = 0


@app.get("/health")
def health():
    return "ok\n"


@app.get("/")
def index():
    global visits
    visits += 1
    return f"Hello from {socket.gethostname()}! Visits: {visits}\n"
