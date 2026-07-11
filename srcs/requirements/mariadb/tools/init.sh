#!/bin/bash
set -eux

SOCKET=/run/mysqld/mysqld.sock

MYSQL_LOCAL=(mariadb --no-defaults --protocol=socket --socket="$SOCKET")
MYSQLADMIN_LOCAL=(mariadb-admin --no-defaults --protocol=socket --socket="$SOCKET")

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d /var/lib/mysql/mysql ]; then
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

mysqld --user=mysql --skip-networking --socket="$SOCKET" & pid="$!"

until "${MYSQLADMIN_LOCAL[@]}" ping --silent; do sleep 1; done

"${MYSQL_LOCAL[@]}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
"${MYSQL_LOCAL[@]}" -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
"${MYSQL_LOCAL[@]}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
"${MYSQL_LOCAL[@]}" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
"${MYSQL_LOCAL[@]}" -e "FLUSH PRIVILEGES;"

"${MYSQLADMIN_LOCAL[@]}" -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown || kill "$pid"
wait "$pid" 2>/dev/null || true

exec mysqld --user=mysql --console
