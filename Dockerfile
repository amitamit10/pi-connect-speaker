# Stage 1: Build librespot from source
FROM rust:1.85-slim AS librespot-builder

RUN apt-get update && apt-get install -y \
    pkg-config \
    libasound2-dev \
    && rm -rf /var/lib/apt/lists/*

RUN cargo install librespot --no-default-features --features alsa-backend

# Stage 2: Final runtime image
FROM python:3.11-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    alsa-utils \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# Copy the pre-built librespot binary from the builder stage
COPY --from=librespot-builder /usr/local/cargo/bin/librespot /usr/local/bin/librespot

# Set up application directory
WORKDIR /app

# Copy the project files
COPY . .

# Install the spotpi Python package
RUN pip install --no-cache-dir .

# Create necessary directories
RUN mkdir -p /etc/spotpi /var/cache/spotpi/audio /etc/spotpi/backups /etc/spotpi/profiles

# Make entrypoint executable
RUN chmod +x docker-entrypoint.sh

# Environment variables
ENV PCS_CONFIG=/etc/spotpi/config.toml
ENV SPOTPI_DOCKER=1
ENV PYTHONUNBUFFERED=1

# Expose the web UI port
EXPOSE 8080

ENTRYPOINT ["./docker-entrypoint.sh"]
