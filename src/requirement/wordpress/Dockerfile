FROM debian:bookworm

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    && rm -rf /var/lib/apt/lists/*

# WordPress 설치
RUN apt-get install -y wget unzip \
    && wget https://wordpress.org/latest.zip \
    && unzip latest.zip -d /var/www/html \
    && rm latest.zip

# PHP-FPM 설정 복사
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# 워드프레스 파일 디렉토리 설정
VOLUME ["/var/www/html"]

# PHP-FPM 실행
CMD ["php-fpm7.4", "-F"]

