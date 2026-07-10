# Inception Developer Documentation #
### A guide for developers using inception ###

## Setup ##
How to set up the environment from scratch with prerequisites, configuration files and secrets

`docker-compose.yml` written in the YAML data serialization language

## Build & Launch ##
How to build and launch the project using the Makefile and Docker Compose

## Commands ##
How to use commends to manage the containers and volumes

To exec into a container: docker compose exec mariadb mariadb -u appuser -p appdb

## Data Storage & Persistence ##
How to find the project data and how it persists

Browser → Nginx (usually 443)
Nginx → WordPress php-fpm (9000)
WordPress → MariaDB (3306)
