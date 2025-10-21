FROM debian:bookworm

ARG WP_VERSION
ENV WP_VERSION=${WP_VERSION}

WORKDIR /root

RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
    wget \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN wget --no-check-certificate https://wordpress.org/wordpress-${WP_VERSION}.tar.gz -P /tmp && \
    tar -xzf /tmp/wordpress-${WP_VERSION}.tar.gz -C /tmp && \
    mkdir -p /var/www/html && \
    mv /tmp/wordpress/* /var/www/html/ && \
    chown -R www-data:www-data /var/www/html && \
    rm -rf /tmp/wordpress /tmp/wordpress-${WP_VERSION}.tar.gz

RUN wget --no-check-certificate https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    mv ./wp-cli.phar /usr/local/bin/wp-cli && \
    chmod +x /usr/local/bin/wp-cli

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
