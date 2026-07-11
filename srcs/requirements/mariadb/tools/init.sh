#!/bin/bash
# MariaDB startup script

# Exit immediately if anything fails
set -eu

# Set SOCKET variable which we will reuse several times
SOCKET=/run/mysqld/mysqld.sock

# Required env vars
required_vars=(
  MYSQL_DATABASE
  MYSQL_USER
  MYSQL_PASSWORD
  MYSQL_ROOT_PASSWORD
)

for var in "${required_vars[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "Error: required environment variable '$var' is not set or empty." >&2
    exit 1
  fi
done

# Create the run directory and let the mysql user own the directory and data
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Initialize the data directory only once
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in the background (no TCP) so we can run commands for
# initialization
mysqld --user=mysql --skip-networking --socket="$SOCKET" & pid="$!"

# Wait until server is ready
until mariadb-admin --protocol=socket --socket="$SOCKET" ping >/dev/null 2>&1; do
    sleep 1
done

# Setup user and password from .env
# DB_CMD=(mariadb --socket="$SOCKET" -e)
DB_CMD=(mariadb --protocol=socket --socket="$SOCKET" -uroot \
-p"${MYSQL_ROOT_PASSWORD}" -e)
"${DB_CMD[@]}" "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
"${DB_CMD[@]}" "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' \
IDENTIFIED BY '${MYSQL_PASSWORD}';"
"${DB_CMD[@]}" "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
"${DB_CMD[@]}" "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
"${DB_CMD[@]}" "FLUSH PRIVILEGES;"

# Stop background MariaDB after changes have been made
mariadb-admin --protocol=socket --socket="$SOCKET" -uroot \
-p"${MYSQL_ROOT_PASSWORD}" shutdown || kill "$pid"
wait "$pid" 2>/dev/null || true

# Start MariaDB in the foreground as PID1
exec mysqld --user=mysql --console
