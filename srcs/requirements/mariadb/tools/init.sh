#!/bin/bash
set -e

# Ensure runtime dir exists
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Start MariaDB in background with explicit networking/socket
mysqld --user=mysql --bind-address=0.0.0.0 --port=3306 --socket=/run/mysqld/mysqld.sock &
pid="$!"

# Wait until server is ready
until mysqladmin ping -h 127.0.0.1 --silent; do
  sleep 1
done

# Initialize DB/user
mysql -uroot <<'EOF'
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'wppassword';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';
FLUSH PRIVILEGES;
EOF

# Keep mysqld in foreground via wait on real pid
wait "$pid"
