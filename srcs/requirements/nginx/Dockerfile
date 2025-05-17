FROM debian:bullseye-20250428@sha256:2a7f95bcf104c8410bf4d3b13c52f6e0e4334bb2edf8d80c7f9881e49447effe

ARG login=dekulow

WORKDIR /root

# Install NGINX && OpenSSL
RUN apt-get update && \
	apt-get install --no-install-recommends -y \
	nginx \
	openssl

# Generate SSL Certificate/Key
RUN openssl req  -nodes -new -x509  \
	-keyout selfsigned.key \
	-out selfsigned.cert \
	-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${login}.42.fr" 

COPY /root/selfsigned.key /etc/ssl/certs/selfsigned.key
COPY /root/selfsigned.crt /etc/ssl/certs/selfsigned.crt

COPY ./conf/default.conf /etc/nginx/sites-available/default

EXPOSE 443/tcp

CMD ["nginx", "-g", "daemon off;"]
