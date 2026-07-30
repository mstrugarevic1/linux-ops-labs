FROM python:3.12-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends procps sysstat coreutils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY app.py .

CMD ["python", "app.py"]
