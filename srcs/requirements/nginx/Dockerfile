FROM debian:bookworm

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    curl \
    apache2-utils && \
    rm -rf /var/lib/apt/lists/*

# 빌드 인자 정의
ARG NGINX_USER_NAME
ARG NGINX_USER_PASSWORD

# .htpasswd 파일 생성
RUN htpasswd -cb /etc/nginx/.htpasswd ${NGINX_USER_NAME} ${NGINX_USER_PASSWORD}

# NGINX 설정 파일 복사
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /etc/ssl/certs
RUN mkdir -p /etc/ssl/private
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/key.pem \
    -out /etc/ssl/certs/cert.pem -subj "/CN=junsan.42.fr/O=Inception Project"

# 포트 개방
EXPOSE 443

# NGINX 실행
CMD ["nginx", "-g", "daemon off;"]
