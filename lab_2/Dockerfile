FROM python:3.12.15-slim-bookworm AS builder
COPY requirements.txt .
RUN pip install --prefix=/install -r requirements.txt

FROM python:3.12.15-slim-bookworm
ENV PYTHONUNBUFFERED=1
COPY --from=builder /install /usr/local
WORKDIR /app
COPY app.py .

RUN useradd app
USER app

EXPOSE 8080
HEALTHCHECK CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/health')"]
ENTRYPOINT ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]
