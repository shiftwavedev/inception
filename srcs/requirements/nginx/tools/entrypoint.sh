#!/bin/sh

# Generate SSL certificate if it doesn't exist
if [ ! -f "/etc/ssl/certs/selfsigned.crt" ]; then
    echo "Generating SSL certificate for ${LOGIN}.42.fr..."
    openssl req -nodes -new -x509 \
        -keyout /etc/ssl/certs/selfsigned.key \
        -out /etc/ssl/certs/selfsigned.crt \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${LOGIN}.42.fr"
fi

# Substitute environment variables in nginx config
echo "Configuring nginx for ${LOGIN}.42.fr..."
envsubst '${LOGIN}' < /etc/nginx/sites-available/default > /tmp/default
mv /tmp/default /etc/nginx/sites-available/default

# Start nginx
echo "Starting nginx..."
exec nginx -g "daemon off;"
