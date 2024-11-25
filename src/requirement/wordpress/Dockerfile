FROM debian:bookworm

# 필수 패키지 설치
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y php8.2 php-fpm php-mysql wget unzip && \
    mkdir -p /var/www/html && \
    wget https://wordpress.org/latest.zip && \
    unzip latest.zip -d /var/www/html && \
    rm latest.zip && \
    rm -rf /var/lib/apt/lists/*

# PHP-FPM 설정 복사
COPY conf/www.conf /etc/php/*/fpm/pool.d/www.conf

# 워드프레스 파일 디렉토리 설정
VOLUME ["/var/www/html"]

# PHP-FPM 실행
CMD ["php-fpm8.2", "-F"]

