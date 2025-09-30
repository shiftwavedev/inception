FROM debian:bullseye-20250428@sha256:2a7f95bcf104c8410bf4d3b13c52f6e0e4334bb2edf8d80c7f9881e49447effe

WORKDIR /root

# Install NGINX, OpenSSL and gettext-base (for envsubst)
RUN apt-get update && \
	apt-get install --no-install-recommends -y \
	nginx \
	openssl \
	gettext-base

# SSL certificates will be generated at runtime by entrypoint

COPY ./conf/default.conf /etc/nginx/sites-available/default

COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443/tcp

ENTRYPOINT ["/entrypoint.sh"]
