# Stage 1: Generate SSL certificates
FROM debian:bullseye-20250428@sha256:2a7f95bcf104c8410bf4d3b13c52f6e0e4334bb2edf8d80c7f9881e49447effe AS cert-builder

ARG LOGIN
ENV LOGIN=${LOGIN}

WORKDIR /certs

RUN apt-get update && \
	apt-get install --no-install-recommends -y openssl && \
	rm -rf /var/lib/apt/lists/*

RUN openssl req -nodes -new -x509 \
	-keyout selfsigned.key \
	-out selfsigned.crt \
	-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${LOGIN}.42.fr"

# Stage 2: Final nginx image (without OpenSSL)
FROM debian:bullseye-20250428@sha256:2a7f95bcf104c8410bf4d3b13c52f6e0e4334bb2edf8d80c7f9881e49447effe

RUN apt-get update && \
	apt-get install --no-install-recommends -y \
	nginx \
	gettext-base \
	curl && \
	rm -rf /var/lib/apt/lists/*

COPY --from=cert-builder /certs/selfsigned.key /etc/ssl/certs/selfsigned.key
COPY --from=cert-builder /certs/selfsigned.crt /etc/ssl/certs/selfsigned.crt

COPY ./conf/default.conf /etc/nginx/sites-available/default

COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 443/tcp

ENTRYPOINT ["/entrypoint.sh"]
