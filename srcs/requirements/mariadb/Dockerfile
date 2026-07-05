# MariaDB Dockerfile

# In modern Dockerfiles we may directly build mariaDB but for Inception we are
# expected to build from an OS (in this case Debian) then install MariaDB on top
# of that.

# Penultimate stable relese (most recent 13.5)
FROM debian:12

# Refresh package index, install MariaDB without interactive prompts and cleanup
# the apt cache to keep files small
RUN apt-get update \
&& apt-get install -y --no-install-recommends mariadb-server \
&& rm -rf /var/lib/apt/lists/*

# Copy the MySQL/MariaDB configuration file which controls:
# network bind address
# port
# character set/collation
# max connections
# logging
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
# Copy custom startup script into the root, script handles:
# starting MariaDB the first time
# creating users and passwords from env
# applying grants
# launching DB in the foreground (exec mysqld)
COPY tools/init.sh /usr/local/bin/init.sh

# Run the startup script
# MariaDB process runs as the mysql user not as root, therefore it must own the
# runtime directory and data directory
RUN chmod +x /usr/local/bin/init.sh \
&& mkdir -p /run/mysqld \
&& chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Default MySQL/MariaDB TCP port
EXPOSE 3306

# /init.sh is the default command when a container starts
# the init script becomes PID 1
# script should end with exec mysqld ... otherwise container exists
CMD ["/usr/local/bin/init.sh"]
