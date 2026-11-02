FROM mcr.microsoft.com/dotnet/sdk:10.0

RUN apt-get update \
    && apt-get install -y --no-install-recommends nano git curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

CMD [ "tail", "-f", "/dev/null" ]