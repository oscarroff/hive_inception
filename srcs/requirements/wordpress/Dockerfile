# Wordpress Dockerfile

# In modern Dockerfiles we may directly build mariaDB but for Inception we are
# expected to build from an OS (in this case Debian) then install MariaDB on top
# of that.

# Penultimate stable relese (most recent 13.5)
FROM debian:12

# Refresh package index, install services required for wordpress without
# interactive prompts and cleanup the apt cache to keep files small
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
	php-fpm \
	php-mysql \
	curl \
	mariadb-client \
	ca-certificates \
&& rm -rf /var/lib/apt/lists/*
# php-fpm - executes the WordPress PHP continer, receives requests from nginx
# php-mysql - extension to connect to MariaDB
# curl - used to download WordPress files during init
# mariadb-client - useful for 'wait until DB is ready'
# ca-certificates - allows us to use https

# Create runtime directory for php-fpm socket/pid if needed
RUN mkdir -p /run/php

# Copy configs and scripts to container
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/init.sh /usr/local/bin/init.sh

# Run initializer
RUN chmod +x /usr/local/bin/init.sh

# Set working directory for content permanence
WORKDIR /var/www/html

# Default TCP port that php-fpm listens on
EXPOSE 9000

# /init.sh is the default command when a container starts
# the init script becomes PID 1
# script should end with exec php-fpm ... otherwise container exits
CMD ["/usr/local/bin/init.sh"]
