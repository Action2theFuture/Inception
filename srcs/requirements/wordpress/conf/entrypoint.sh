#!/bin/bash

set -x

echo "Running as $(whoami)" 

sleep 10
WP_CONFIG_PATH=/var/www/wordpress/wp-config.php
CONFIG_LOG_PATH=/var/www/wordpress/wp_config_log.txt
CORE_LOG_PATH=/var/www/wordpress/wp_core_log.txt
USER_LOG_PATH=/var/www/wordpress/wp_user_log.txt
WORDPRESS_PATH=/var/www/wordpress

echo "DB_NAME=$WORDPRESS_DB_NAME"
echo "DB_USER=$WORDPRESS_DB_USER"
echo "DB_PASSWORD=$WORDPRESS_DB_PASSWORD"
echo "DB_HOST=$WORDPRESS_DB_HOST"

cd $WORDPRESS_PATH;

sleep 10;

# Check if wp-config.php exists and validate its content
if [ ! -s "$WP_CONFIG_PATH" ] || ! grep -q "define('DB_NAME', '$WORDPRESS_DB_NAME');" "$WP_CONFIG_PATH"; then
    echo "Creating wp-config.php for $DOMAIN_NAME" >> "$CONFIG_LOG_PATH"
    
    # If wp-config.php exists but is incomplete or invalid, delete it
    if [ -e "$WP_CONFIG_PATH" ]; then
        echo "wp-config.php exists but is incomplete. Deleting and recreating..." >> "$CONFIG_LOG_PATH"
        rm -f "$WP_CONFIG_PATH"
    fi

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
    echo "Inception : ✔ Download core wordpress files to $WORDPRESS_PATH"
    wp core install --url="$DOMAIN_NAME" \
        --title="Test Site" \
        --admin_user="admin" \
        --admin_password="1q2w3e4r" \
        --admin_email="admin@test.com" \
        --allow-root --path="." >> "$CORE_LOG_PATH" 2>&1

    if [ $? -ne 0 ]; then
        echo "Failed to install WordPress. Check $CORE_LOG_PATH for details." >> "$CORE_LOG_PATH"
        cat "$CORE_LOG_PATH"
        exit 1
    fi
else
    echo "wp-config.php exists and is valid. Updating database configuration." >> "$CONFIG_LOG_PATH"

    # Update database settings in existing wp-config.php
    wp config set DB_NAME "$WORDPRESS_DB_NAME" --allow-root --path="." >> "$CONFIG_LOG_PATH" 2>&1
    wp config set DB_USER "$WORDPRESS_DB_USER" --allow-root --path="." >> "$CONFIG_LOG_PATH" 2>&1
    wp config set DB_PASSWORD "$WORDPRESS_DB_PASSWORD" --allow-root --path="." >> "$CONFIG_LOG_PATH" 2>&1
    wp config set DB_HOST "$WORDPRESS_DB_HOST" --allow-root --path="." >> "$CONFIG_LOG_PATH" 2>&1
fi

# Ensure ownership and permissions
chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress

echo "wordpress start !!"
/usr/sbin/php-fpm8.2 -F