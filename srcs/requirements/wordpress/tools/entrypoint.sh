#!/bin/sh

# Create PHP-FPM runtime directory
mkdir -p /run/php
chown www-data:www-data /run/php

# Configure WordPress
wp-cli config create --allow-root \
		--dbname=$SQL_DATABASE \
		--dbuser=$SQL_USER \
		--dbpass=$SQL_PASSWORD \
		--dbhost=mariadb:3306 --path='/var/www/html'

# Start PHP-FPM
exec /usr/sbin/php-fpm7.4 -F
