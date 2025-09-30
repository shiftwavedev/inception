#!/bin/sh

# Substitute environment variables in nginx config
echo "Configuring nginx for ${LOGIN}.42paris.fr..."
envsubst '${LOGIN}' < /etc/nginx/sites-available/default > /tmp/default
mv /tmp/default /etc/nginx/sites-available/default

# Start nginx
echo "Starting nginx..."
exec nginx -g "daemon off;"
