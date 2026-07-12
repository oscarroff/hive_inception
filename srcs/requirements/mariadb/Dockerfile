FROM debian:12

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	mariadb-server \
    && rm -rf /var/lib/apt/lists/*

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 3306
CMD ["/init.sh"]
