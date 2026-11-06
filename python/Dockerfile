FROM python:3.14-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Install some utils
RUN apt-get update && apt-get install -y nano git curl

RUN mkdir -p /app

WORKDIR /app