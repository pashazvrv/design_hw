#!/bin/bash
cd /opt/app || exit 1

if [ -f app.pid ] && kill -0 "$(cat app.pid)" 2>/dev/null; then
    echo "already running"
    exit 0
fi

venv/bin/gunicorn --daemon --pid app.pid -b 0.0.0.0:8080 app:app
echo "started"
