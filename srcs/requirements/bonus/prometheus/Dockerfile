FROM debian:bookworm

# 기본 패키지 업데이트 및 필요한 패키지 설치
RUN apt-get update && \
    apt-get install -y wget tar && \
    rm -rf /var/lib/apt/lists/*

# Prometheus 설치
ENV PROMETHEUS_VERSION=2.47.0

RUN wget https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz -O /tmp/prometheus.tar.gz && \
    tar -xzf /tmp/prometheus.tar.gz -C /usr/local/bin --strip-components=1 prometheus-$PROMETHEUS_VERSION.linux-amd64/prometheus prometheus-$PROMETHEUS_VERSION.linux-amd64/promtool && \
    mkdir -p /etc/prometheus && \
    tar -xzf /tmp/prometheus.tar.gz -C /etc/prometheus --strip-components=1 prometheus-$PROMETHEUS_VERSION.linux-amd64/prometheus.yml prometheus-$PROMETHEUS_VERSION.linux-amd64/consoles prometheus-$PROMETHEUS_VERSION.linux-amd64/console_libraries && \
    rm -rf /tmp/prometheus.tar.gz prometheus-$PROMETHEUS_VERSION.linux-amd64

# 포트 개방
EXPOSE 9090

COPY prometheus.yml /etc/prometheus/prometheus.yml
# Prometheus 실행
CMD ["prometheus", "--config.file=/etc/prometheus/prometheus.yml", "--storage.tsdb.path=/prometheus"]
