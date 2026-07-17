# Inception Developer Documentation #
### A guide for developers using inception ###

## Setup ##
How to set up the environment from scratch with prerequisites, configuration files and secrets

### Prerequesites ###
- docker, curl, apt

### Configuration Files & Secrets ###
Inception requires a .env file to build. An example is provided in the repository srcs/.env_example. This file should contain a set of secrets and credentials and be stored at srcs/.env. In order for the project to build we need the bare minimum of the following variables to allow correct configuration of the database and connecting services:
`DOMAIN_NAME
MYSQL_DATABASE
MYSQL_USER
MYSQL_PASSWORD
MYSQL_ROOT_PASSWORD`
Optional but useful additional variables are:
`WP_ADMIN_USER
WP_ADMIN_PASSWORD
WP_ADMIN_EMAIL
WP_USER
WP_USER_PASSWORD
WP_USER_EMAIL`

`docker-compose.yml` written in the YAML data serialization language

## Build & Launch ##
How to build and launch the project using the Makefile and Docker Compose
### Makefile Setup ###
1. Clone the repository and navgate to project root `git clone <repo url> && cd <repo name>`
2. Create a .env file at srcs/.env ([see Credentials](#Credentials))
3. Build and launch `make up`
4. Access the website (optional) ([see Website & Admin Panel](#Website-&-Admin-Panel))
5. Stop the project `make down` or to wipe `make fclean`

### Docker Compose Setup ###
1. Clone the repository and navgate to project root `git clone <repo url> && cd <repo name>`
2. Navigate to root of docker project `cd <repo name>/srcs`
3. Build and launch `docker compose up --build`
4. Access the website (optional) ([see Website & Admin Panel](#Website-&-Admin-Panel))
5. Stop the project `docker compose down` or to wipe `docker compose down -v && sudo rm -rf /home/$USER/data/mariadb/* && sudo rm -rf /home/$USER/data/wordpress/* && docker system prune -af`

## Commands ##
How to use commands to manage the containers and volumes

To exec into a container: docker compose exec mariadb mariadb -u appuser -p appdb

## Data Storage & Persistence ##
How to find the project data and how it persists
This project uses bind mounts to store data that persists between builds and restarts. Only in the case of a clean wipe such as with `make fclean` will this data be erased. The two volumes that store this data are:
- `/home/${USER}/data/mariadb` for database data
- `/home/${USER}/data/wordpress` for wordpress data
By using a bind mount these files are easily accessible in a static location on the host machine. Other data, such as the Debian images for each container and installations within each container are created with the first build and will then persist between restarts. Rebuilds will however involve the deletion and recreation of these files.

## Ports & Networks ###
This docker project uses several internal exposed ports on a docker network to allow communication between containers, plus an outward facing exposed port from Nginx to allow requests and responses over HTTP. These are:
- Browser → Nginx on 443
    * exposed to computer
    * handles HTTP connections
- Nginx → WordPress php-fpm on 9000
    * exposed internally on docker network
    * handles communication between server and content management system
- WordPress → MariaDB on 3306
    * exposed internally on docker network
    * handles communication betwen contnt managment system and database
In addition to these ports, the VM layer (if used) will requir the use of port forwarding to give access to both docker commands and the website. An example of this could be 4243 -> 22 for ssh terminal access and 8442 -> 443 for http connections. N.B. Use of ports above 1024 on the host machine avoids the need for sudo rights.
