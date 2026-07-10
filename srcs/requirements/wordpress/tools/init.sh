#!/bin/bash
set -eu

# Required env vars
required_vars=(
  MYSQL_DATABASE
  MYSQL_USER
  MYSQL_PASSWORD
  MYSQL_HOST
  WP_ADMIN_USER
  WP_ADMIN_PASSWORD
  WP_ADMIN_EMAIL
  WP_USER
  WP_USER_PASSWORD
  WP_USER_EMAIL
  DOMAIN_NAME
)

for var in "${required_vars[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "Error: required environment variable '$var' is not set or empty." >&2
    exit 1
  fi
done

mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

cd /var/www/html

# Install wp-cli once (lightweight approach for setup)
if [ ! -f /usr/local/bin/wp ]; then
  curl -fsSL https://raw.githubusercontent.com/wp-cli/wp-cli/v2.10.0/phar/wp-cli.phar -o /usr/local/bin/wp
  chmod +x /usr/local/bin/wp
fi

# Wait for MariaDB
until mariadb-admin ping -h"${MYSQL_HOST}" -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
  sleep 2
done

# Download WordPress core if not already present
if [ ! -f wp-settings.php ]; then
  wp core download --allow-root
fi

# Create wp-config.php once
if [ ! -f wp-config.php ]; then
  wp config create \
    --allow-root \
    --dbname="${MYSQL_DATABASE}" \
    --dbuser="${MYSQL_USER}" \
    --dbpass="${MYSQL_PASSWORD}" \
    --dbhost="${MYSQL_HOST}" \
    --path=/var/www/html
fi

# Install WordPress once
if ! wp core is-installed --allow-root; then
  wp core install \
    --allow-root \
    --url="${DOMAIN_NAME}" \
    --title="Inception" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email

  wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
    --allow-root \
    --user_pass="${WP_USER_PASSWORD}" \
    --role=author
fi

chown -R www-data:www-data /var/www/html

exec php-fpm8.2 -F
