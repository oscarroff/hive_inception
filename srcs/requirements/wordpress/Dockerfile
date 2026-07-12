FROM debian:12

RUN apt-get update && apt-get install -y --no-install-recommends \
php-fpm \
php-mysql \
wget \
curl \
&& rm -rf /var/lib/apt/lists/*

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 9000
CMD ["/init.sh"]
