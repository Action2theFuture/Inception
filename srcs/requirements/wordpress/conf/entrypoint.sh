#!/bin/bash

# Check if /var/www/wordpress/wp-config.php doesn't exist
if [ ! -e /var/www/wordpress/wp-config.php ]; then
    echo "CREATION WP-CONFIG.PHP on $DOMAIN_NAME"
    
    # Create the wp-config.php file using wp-cli
    wp config create --allow-root \
        --dbname=$WORDPRESS_DB_DATABASE \
        --dbuser=$WORDPRESS_DB_USER \
        --dbpass=$WORDPRESS_DB_PASSWORD \
        --dbhost=$WORDPRESS_DB_HOST --path='/var/www/html/wordpress'

    # Install WordPress using wp-cli
    wp core install --url=$DOMAIN_NAME \
        --title=$SITE_TITLE \
        --admin_user=$ADMIN_USER \
        --admin_password=$ADMIN_PASSWORD \
        --admin_email=$ADMIN_EMAIL \
        --allow-root --path='/var/www/html/wordpress'

    # Create a user using wp-cli
    wp user create --allow-root --role=author $USER1_LOGIN $USER1_MAIL \
        --user_pass=$USER1_PASS --path='/var/www/html/wordpress' >> /log.txt
fi

# Start PHP-FPM 7.3 in the background
/usr/sbin/php-fpm8.2 -F
