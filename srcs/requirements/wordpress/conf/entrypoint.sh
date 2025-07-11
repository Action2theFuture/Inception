#!/bin/bash

set -x

echo "Running as $(whoami)" 

WP_CONFIG_PATH=/var/www/wordpress/wp-config.php
CONFIG_LOG_PATH=/var/www/wordpress/wp_config_log.txt
CORE_LOG_PATH=/var/www/wordpress/wp_core_log.txt
USER_LOG_PATH=/var/www/wordpress/wp_user_log.txt
REDIS_LOG_PATH=/var/www/wordpress/wp_redis_log.txt
WORDPRESS_PATH=/var/www/wordpress

echo "DB_NAME=$WORDPRESS_DB_NAME"
echo "DB_USER=$WORDPRESS_DB_USER"
echo "DB_PASSWORD=$WORDPRESS_DB_PASSWORD"
echo "DB_HOST=$WORDPRESS_DB_HOST"

sleep 10;

WP_CONFIG_EXISTS=false
if [ -f "$WP_CONFIG_PATH" ] ; then
    WP_CONFIG_EXISTS=true
fi

WP_INSTALLED=false
if wp core is-installed --allow-root --path="$WORDPRESS_PATH" >/dev/null 2>&1; then
    WP_INSTALLED=true
fi

echo "WP_CONFIG_EXISTS=$WP_CONFIG_EXISTS, WP_INSTALLED=$WP_INSTALLED"

# Check if wp-config.php exists and validate its content
if [ "$WP_CONFIG_EXISTS" = "false" ] || [ "$WP_INSTALLED" = "false" ]; then
    
    echo "[init] WordPress is not fully set up (config or DB missing). Let's install."

    cd $WORDPRESS_PATH
    rm -rf $WORDPRESS_PATH/*
    echo "[init] Cleaned up existing WordPress folder."

    echo "Inception: ✔ Download core file" >> "$CONFIG_LOG_PATH"
    wp core download --allow-root --path="$WORDPRESS_PATH" >> "$CONFIG_LOG_PATH"

    echo "Creating wp-config.php for $DOMAIN_NAME" >> "$CONFIG_LOG_PATH"
    # Create wp-config.php
    wp config create --allow-root \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --path="." >> "$CONFIG_LOG_PATH" 2>&1
    
    if [ $? -ne 0 ]; then
        echo "Failed to create wp-config.php. Check $CORE_LOG_PATH for details." >> "$CONFIG_LOG_PATH"
        cat "$CONFIG_LOG_PATH"
        exit 1
    fi

    # Install WordPress
    echo "Inception : ✔ Download core wordpress files to $WORDPRESS_PATH" >> "$CORE_LOG_PATH" 2>&1
    wp core install --url="$DOMAIN_NAME" \
        --title="Test Site" \
        --admin_user="$WORDPRESS_ADMIN_NAME" \
        --admin_password="1q2w3e4r" \
        --admin_email="junsan@test.com" \
        --allow-root --path="." >> "$CORE_LOG_PATH" 2>&1

    if [ $? -ne 0 ]; then
        echo "Failed to install WordPress. Check $CORE_LOG_PATH for details." >> "$CORE_LOG_PATH"
        cat "$CORE_LOG_PATH"
        exit 1
    fi

    echo "Creating wp-config.php for $WORDPRESS_DB_NAME" >> "$USER_LOG_PATH" 2>&1
    wp user create "$WORDPRESS_DB_NAME" "mysql@test.com" \
        --role=editor \
        --user_pass=${WORDPRESS_DB_PASSWORD} \
        --allow-root --path="." >> "$USER_LOG_PATH" 2>&1

    # add redis cache setting
    echo "Configuring Redis cache settings in wp-config.php" >> "$REDIS_LOG_PATH"
    wp config set WP_CACHE true --raw --allow-root --path="." >> "$REDIS_LOG_PATH" 2>&1
    wp config set WP_REDIS_HOST "redis" --allow-root --path="." >> "$REDIS_LOG_PATH" 2>&1
    wp config set WP_REDIS_PORT 6379 --allow-root --path="." >> "$REDIS_LOG_PATH" 2>&1
    wp config set WP_REDIS_DATABASE 0 --allow-root --path="." >> "$REDIS_LOG_PATH" 2>&1

    # Redis 플러그인 설치 및 활성화
    wp plugin install redis-cache --allow-root --path="." >> "$REDIS_LOG_PATH" 2>&1
    wp plugin activate redis-cache --allow-root --path="." >> "$REDIS_LOG_PATH" 2>&1

    # Redis 캐시 활성화
    wp redis enable --allow-root --path="." >> "$REDIS_LOG_PATH" 2>&1
else
    echo "[init] WordPress config + DB are already present. Skipping re-install."
fi

# Ensure ownership and permissions
chown -R www-data:www-data "$WORDPRESS_PATH"
chmod -R 755 "$WORDPRESS_PATH"

echo "wordpress start !!"
exec "$@"
