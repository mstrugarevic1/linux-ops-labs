FROM python:3.12-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends procps curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY client.py server.py .
