FROM condaforge/miniforge3@sha256:0a788afa8b54165d855d08552ce6d86e1e2553be2a9a18d542c69cfb02a6deaa

# Add UV binaries from the specified image
COPY --from=ghcr.io/astral-sh/uv@sha256:96f40d3904aad8d0bd010539001d36c8e2188b981e1334471a90c4a1d93bb490 /uv /uvx /bin/

# Install Python 3.14 in the base Conda environment
RUN conda install --yes --name base "python=3.14" \
    && conda clean --all --yes

# Install system utils and build essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
    nano \
    git \
    curl \
    make \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app