#!/bin/bash

set -e 

# echo "MYSQL_USER=$MYSQL_USER"
# echo "MYSQL_DATABASE=$MYSQL_DATABASE"

WORDPRESS_PATH="/var/www/html"

MYSQL_PASSWORD=$(cat /run/secrets/db_password)

# echo "PASSWORD=[$MYSQL_PASSWORD]"

echo "Waiting for MariaDB..."

until mariadb \
         -h mariadb \
            -u"$MYSQL_USER" \
                -p"$MYSQL_PASSWORD" \
                    -e "SELECT 1" >/dev/null 2>&1 
do
    sleep 2
done

echo "Database connection succeeded."



echo "MariaDB is ready."

mkdir -p "$WORDPRESS_PATH"

cd "$WORDPRESS_PATH"

if [ ! -f wp-config.php ]; then 

    echo "Downloading WordPress..."

    wp core download \
        --allow-root

    echo "Creating wp-config.php..."
    
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="mariadb:3306" \
        --allow-root

    echo "Installing WordPress..."

    wp core install \
        --url="$DOMAIN_NAME" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WORDPRESS_ADMIN" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --skip-email \
        --allow-root
    
    echo "Creating WordPress user..."

    wp user create \
        "$WORDPRESS_USER" \
        "$WORDPRESS_USER_EMAIL" \
        --role=author \
        --user_pass="$WORDPRESS_USER_PASSWORD" \
        --allow-root
    
    echo " redis caching bonus "

    wp plugin install redis-cache --activate --allow-root

    wp config set WP_REDIS_HOST redis --allow-root 

    wp config set WP_REDIS_PORT  6379 --raw --allow-root 

    wp redis enable --allow-root

fi

echo "Setting permissions..."


chown -R www-data:www-data "$WORDPRESS_PATH"
chgrp -R www-data /var/www/html
chmod -R g+w /var/www/html

mkdir -p /run/php

echo "<< Everything Done ! >>"

exec php-fpm7.4 -F