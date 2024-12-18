# Use penultimate stable version of Alpine or Debian
FROM debian:bookworm

# 기본 패키지 업데이트 및 필요한 패키지 설치
RUN apt-get update && \
    apt-get install -y wget tar curl && \
    rm -rf /var/lib/apt/lists/*

ENV VERSION=1.67.0

# Download and extract nginx-prometheus-exporter
RUN wget https://github.com/oliver006/redis_exporter/releases/download/v${VERSION}/redis_exporter-v${VERSION}.linux-amd64.tar.gz \
    && tar -xzf redis_exporter-v${VERSION}.linux-amd64.tar.gz \
    && mv redis_exporter-v${VERSION}.linux-amd64/redis_exporter /usr/local/bin/ \
    && chmod +x /usr/local/bin/redis_exporter \
    && rm -rf redis-exporter-v${VERSION}.linux-amd64.tar.gz redis_exporter-v${VERSION}.linux-amd64 

# Expose port 9121
EXPOSE 9121

# Set entrypoint
ENTRYPOINT ["redis_exporter", "--redis.addr=redis:6379"]