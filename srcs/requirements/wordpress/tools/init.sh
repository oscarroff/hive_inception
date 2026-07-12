#!/bin/sh
set -e

mkdir -p /var/www/html /run/php /tmp

# Download WordPress tarball with curl (fails hard if download fails)
curl -fsSL https://wordpress.org/latest.tar.gz -o /tmp/latest.tar.gz
tar -xzf /tmp/latest.tar.gz -C /tmp
cp -a /tmp/wordpress/. /var/www/html/

# Start php-fpm in foreground (Debian 12)
exec php-fpm8.2 -F
