FROM condaforge/miniforge3:26.9.4-2 AS miniforge

FROM python:3.14-slim

# Add UV binaries from the specified image
COPY --from=ghcr.io/astral-sh/uv:0.13.7 /uv /uvx /bin/
COPY --from=miniforge /opt/conda /opt/conda

# Set up Conda environment for Python 3.14
ENV PATH="/opt/conda/condabin:${PATH}"

# Create and configure the base Conda environment for Python 3.14
RUN conda install --yes --name base "python=3.14" \
    && conda config --system --set auto_activate_base false \
    && conda init bash \
    && conda clean --all --yes

# Install system utils and build essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
    nano \
    git \
    curl \
    make \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory for the application
WORKDIR /app