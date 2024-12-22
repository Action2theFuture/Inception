FROM debian:bookworm

ENV PHP_VERSION=8.2

ENV WORDPRESS_VERSION=6.7.1

ENV REDIS_CACHE_VERSION=2.5.4

# 필수 패키지 설치
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    php${PHP_VERSION} php${PHP_VERSION}-fpm php${PHP_VERSION}-mysql php${PHP_VERSION}-redis \
    wget unzip net-tools curl vim telnet dnsutils iproute2 iputils-ping \
    redis-tools && \
    mkdir -p /var/www && \
    wget https://wordpress.org/wordpress-${WORDPRESS_VERSION}.zip && \
    unzip wordpress-${WORDPRESS_VERSION}.zip -d /var/www && \
    rm wordpress-${WORDPRESS_VERSION}.zip && \
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp && \
    ln -s /usr/local/bin/wp /usr/bin/wp && \
    sed -i 's/^listen = .*/listen = 0.0.0.0:9000/' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf && \
    wp --info || echo "WP-CLI install inspect completed" && \
    wget https://downloads.wordpress.org/plugin/redis-cache.${REDIS_CACHE_VERSION}.zip && \
    mkdir -p /var/www/wordpress/wp-content/plugins && \
    unzip redis-cache.${REDIS_CACHE_VERSION}.zip -d /var/www/wordpress/wp-content/plugins && \
    rm -rf redis-cache.${REDIS_CACHE_VERSION}.zip && \
    rm -rf /var/lib/apt/lists/*

# PHP-FPM 설정 복사
COPY /conf/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

COPY /conf/entrypoint.sh /usr/local/bin/wp_entrypont.sh

RUN chmod 755 /usr/local/bin/wp_entrypont.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp_entrypont.sh"]

CMD php-fpm${PHP_VERSION} -F
