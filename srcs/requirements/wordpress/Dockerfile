FROM debian:bookworm

# 필수 패키지 설치
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y php8.2 php-fpm php-mysql wget unzip && \
    mkdir -p /var/www/html && \
    wget https://wordpress.org/latest.zip && \
    unzip latest.zip -d /var/www/html && \
    rm latest.zip && \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp && \
    rm -rf /var/lib/apt/lists/*

# PHP-FPM 설정 복사
COPY conf/www.conf /etc/php/*/fpm/pool.d/www.conf

COPY --chmod=0755 /conf/entrypoint.sh /usr/local/bin/wp_entrypont.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp_entrypont.sh"]
