#!/bin/sh

# Create PHP-FPM runtime directory
mkdir -p /run/php
chown www-data:www-data /run/php

# Read secrets
SQL_PASSWORD=$(cat /run/secrets/db_password)

WP_ADMIN_USER=$(sed -n '1p' /run/secrets/credentials)
WP_ADMIN_PASSWORD=$(sed -n '2p' /run/secrets/credentials)
WP_ADMIN_EMAIL=$(sed -n '3p' /run/secrets/credentials)
WP_USER=$(sed -n '4p' /run/secrets/credentials)
WP_USER_PASSWORD=$(sed -n '5p' /run/secrets/credentials)
WP_USER_EMAIL=$(sed -n '6p' /run/secrets/credentials)

# Check if WordPress is already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Configuring WordPress..."

    # Create wp-config.php
    wp-cli config create --allow-root \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --path='/var/www/html'

    # Install WordPress
    echo "Installing WordPress..."
    wp-cli core install --allow-root \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path='/var/www/html'

    # Create additional user
    echo "Creating WordPress user..."
    wp-cli user create --allow-root \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --path='/var/www/html'

    echo "WordPress installation completed!"
else
    echo "WordPress already installed, skipping setup..."
fi

# Start PHP-FPM
exec /usr/sbin/php-fpm7.4 -F
