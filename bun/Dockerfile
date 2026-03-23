FROM oven/bun:1.2.5

RUN apt-get update \
    && apt-get install -y --no-install-recommends nano git curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app

WORKDIR /app

USER bun

CMD [ "tail", "-f", "/dev/null" ]