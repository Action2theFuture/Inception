FROM debian:bookworm

# Redis 설치
RUN apt-get update && \
    apt-get install -y redis-server && \
    rm -rf /var/lib/apt/lists/*

# Redis 설정 파일 복사
COPY conf/redis.conf /usr/local/etc/redis/redis.conf

# 포트 설정
EXPOSE 6379
# Redis 실행
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]