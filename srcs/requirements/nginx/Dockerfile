FROM debian:bookworm

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# NGINX 설정 파일 복사
COPY conf/nginx.conf /etc/nginx/nginx.conf

# TLS 인증서 및 키 복사
COPY conf/cert.pem /etc/ssl/certs/
COPY conf/key.pem /etc/ssl/private/

# 포트 개방
EXPOSE 443

# NGINX 실행
CMD ["nginx", "-g", "daemon off;"]
