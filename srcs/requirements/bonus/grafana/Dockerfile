FROM debian:bookworm

# 기본 패키지 업데이트 및 필요한 패키지 설치
RUN apt-get update && \
    apt-get install -y wget gnupg2 && \
    wget -q -O - https://packages.grafana.com/gpg.key | apt-key add - && \
    echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list && \
    apt-get update && \
    apt-get install -y grafana && \
    rm -rf /var/lib/apt/lists/*

# Grafana 설정 파일 복사 (필요 시)
COPY provisioning /etc/grafana/provisioning

# 플러그인 디렉토리 생성 및 권한 설정
RUN mkdir -p /usr/share/grafana/data/plugins && \
    chown -R grafana:grafana /usr/share/grafana/data/plugins && \
    chmod -R 755 /usr/share/grafana/data/plugins

# 엔트리포인트 스크립트 복사 및 권한 설정
COPY entrypoint.sh /usr/local/bin/grafana_entrypoint.sh
RUN chmod +x /usr/local/bin/grafana_entrypoint.sh

USER grafana

# 포트 개방
EXPOSE 3000

# 엔트리포인트 스크립트 설정
ENTRYPOINT ["/usr/local/bin/grafana_entrypoint.sh"]

# Grafana 실행
CMD ["grafana-server", "--homepath=/usr/share/grafana", "cfg:default.paths.data=/var/lib/grafana"]
