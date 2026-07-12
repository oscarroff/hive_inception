#!/bin/bash
set -eux

SOCKET=/run/mysqld/mysqld.sock

required_vars=(
  MYSQL_DATABASE
  MYSQL_USER
  MYSQL_PASSWORD
  MYSQL_ROOT_PASSWORD
)
for var in "${required_vars[@]}"; do
  [ -n "${!var:-}" ] || { echo "Missing $var" >&2; exit 1; }
done

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d /var/lib/mysql/mysql ]; then
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

mysqld --user=mysql --skip-networking --socket="$SOCKET" &
pid="$!"

until mariadb-admin --no-defaults --protocol=socket --socket="$SOCKET" ping --silent; do
  sleep 1
done

mariadb --no-defaults --protocol=socket --socket="$SOCKET" -uroot -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mariadb --no-defaults --protocol=socket --socket="$SOCKET" -uroot -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mariadb --no-defaults --protocol=socket --socket="$SOCKET" -uroot -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
mariadb --no-defaults --protocol=socket --socket="$SOCKET" -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mariadb --no-defaults --protocol=socket --socket="$SOCKET" -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

mariadb-admin --no-defaults --protocol=socket --socket="$SOCKET" -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown || kill "$pid"
wait "$pid" 2>/dev/null || true

exec mysqld --user=mysql --console
