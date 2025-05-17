#!/bin/sh

wp-cli config create --allow-root \
		--dbname=$SQL_DATABASE \
		--dbuser=$SQL_USER \
		--dbpass=$SQL_PASSWORD \
		--dbhost=mariadb:3306 --path='/var/www/wordpress'

/usr/sbin/php-fpm7.4 -F
