FROM python:3.12-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends default-mysql-client procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY app.py .

CMD ["python", "app.py"]
