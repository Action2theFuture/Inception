# Use penultimate stable version of Alpine or Debian
FROM debian:bookworm

# 기본 패키지 업데이트 및 필요한 패키지 설치
RUN apt-get update && \
    apt-get install -y wget tar curl && \
    rm -rf /var/lib/apt/lists/*

ENV VERSION=1.4.0

# Download and extract nginx-prometheus-exporter
RUN wget https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v${VERSION}/nginx-prometheus-exporter_${VERSION}_linux_amd64.tar.gz \
    && tar -xzf nginx-prometheus-exporter_${VERSION}_linux_amd64.tar.gz \
    && mv nginx-prometheus-exporter /usr/local/bin/ \
    && chmod +x /usr/local/bin/nginx-prometheus-exporter \
    && rm -rf nginx-prometheus-exporter_${VERSION}_linux_amd64.tar.gz

# Expose port 9113
EXPOSE 9113

# Set entrypoint
ENTRYPOINT ["nginx-prometheus-exporter", "--nginx.scrape-uri=http://nginx:80/nginx_status"]
