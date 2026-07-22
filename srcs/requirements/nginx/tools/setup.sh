#!/bin/bash
set -e

mkdir -p /etc/ssl/private /etc/ssl/certs

openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/ssl/private/inception.key \
  -out /etc/ssl/certs/inception.crt \
  -subj "/C=FI/ST=Uusimaa/L=Helsinki/O=42/OU=Hive/CN=${DOMAIN_NAME}"

# Replace hardcoded server_name with env value at runtime
sed -i "s/server_name .*/server_name ${DOMAIN_NAME};/" /etc/nginx/nginx.conf

exec nginx -g "daemon off;"
