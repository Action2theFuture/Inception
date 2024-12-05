FROM debian:bookworm

# 필수 패키지 설치
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    php8.2 php-fpm php-mysql php-redis \
    wget \
    unzip \
    net-tools \
    curl \
    vim \
    telnet \
    redis-tools && \
    mkdir -p /var/www && \
    wget https://wordpress.org/latest.zip && \
    unzip latest.zip -d /var/www && \
    rm latest.zip && \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp && \
    wp --info || echo "WP-CLI install inspect completed" && \
    wget https://downloads.wordpress.org/plugin/redis-cache.latest-stable.zip && \
    unzip redis-cache.latest-stable.zip -d /var/www/wordpress/wp-content/plugins && \
    rm -rf redis-cache.latest-stable.zip && \
    rm -rf /var/lib/apt/lists/*

# PHP-FPM 설정 복사
COPY /conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY --chmod=0755 /conf/entrypoint.sh /usr/local/bin/wp_entrypont.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp_entrypont.sh"]
