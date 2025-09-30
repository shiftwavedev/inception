FROM debian:bullseye-20250428@sha256:2a7f95bcf104c8410bf4d3b13c52f6e0e4334bb2edf8d80c7f9881e49447effe

ARG VERSION_WORDPRESS=6.8.1

WORKDIR /root

# Install PHP && MariaDB-Client
RUN apt-get update && apt-get upgrade -y && \
	apt-get install --no-install-recommends -y \
	wget \
	php7.4 \
	php7.4-fpm \
	php7.4-mysql \
	mariadb-client && \
	rm -rf /var/lib/apt/lists/*

# Download and install wordpress data
RUN wget --no-check-certificate https://wordpress.org/wordpress-${VERSION_WORDPRESS}.tar.gz -P /tmp && \
	tar -xzf /tmp/wordpress-${VERSION_WORDPRESS}.tar.gz -C /tmp && \
	mkdir -p /var/www/html && \
	mv /tmp/wordpress/* /var/www/html/ && \
	chown -R www-data:www-data /var/www/html && \
	rm -rf /tmp/wordpress /tmp/wordpress-${VERSION_WORDPRESS}.tar.gz

# Download and install exec wp-cli
RUN wget --no-check-certificate https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	mv ./wp-cli.phar /usr/local/bin/wp-cli && \
	chmod +x /usr/local/bin/wp-cli

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
