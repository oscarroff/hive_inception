# Inception User Documentation #
### A guide for users and administrators of inception ###

N.B. The following explanations assume the project is installed locally. For installation inside a virtual machine [see VM installation](#VM-Installation).

## Services ##
Inception is a full-stack project that requires the use of 3 services: mariaDB, WordPress and nginx. Each service is installed and setup in its own dedicated docker container running on the penultimate stable release of Debian (in this case 12 bookworm).
The services and their roles are as follows:-
- mariaDB: backend open-source database management system
- WordPress: frontend content management system
- Nginx: web server handler for HTTP requests and responses

## Setup & Exit ##
How to start and stop the project
1. Clone the repository and navgate to project root `git clone <repo url> && cd <repo name>`
2. Create a .env file at srcs/.env ([see Credentials](#Credentials))
3. Build and launch `make up`
4. Access the website (optional) ([see Website & Admin Panel](#Website-&-Admin-Panel))
5. Stop the project `make down` or to wipe `make fclean`

## Website & Admin Panel ##
How to access the website and the administration panel
(assuming the project is already running)
- Access the website at [thblack.42.fr](thblack.42.fr)
- Log in to the administration panel via [thblack.42.fr/wp-login.php](thblack.42.fr/wp-login.php) using the credentials set in srcs/.env

## Credentials ##
How to locate and manage credentials
Credentials should be stored in a .env file at srcs/.env - an example file .env_example is provided in the repo. In order for the project to build we need the bare minimum of the following variables to allow correct configuration of the database and connecting services:
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

## Monitoring ##
How to check that the services are running correctly
(assuming the project is already running)
### Check Status ###
To see the state of the 3 services:
1. Navigate to the project root
2. Run the command `make ps`
### View Logs ###
To view the logs of the 3 services:
1. Navigate to the project root
2. Run the command `make logs`

## VM Installation ##
At Hive, Helsinki (a 42 network school) it is essential to run Inception inside a virtual machine in order to gain sudo rights. In the following examples a headless install of Debian 13 is assumed.
### Credentials ###
Ensure that you have a user with sudo rights on the VM. If necessary edit the sudoers with the command `sudo visudo`
### Ports ###
For the following `ssh` commands to work we need to setup port forwarding
1. Set Adapter 1 in the VM settings to NAT
2. Open the Port Forwarding window
3. Add a rule for terminal access e.g. name: ssh, protocol: TCP, host IP: 127.0.0.1, host port: 4243, guest port 4242
4. Add a rule for X11 access e.g. name: xwin, protocol: TCP, host IP: 127.0.0.1, host port: 8443, guest port 443
### SSH ###
In order to interact with the VM locally we can then use ssh with the command: `ssh -p 4243 user@localhost`
Additionally access to the website can be made local via X11:
1. Install firefox on the VM `sudo apt update && sudo apt install firefox-esr`
2. Enable X11 forwarding on the VM:
- `sudo nano /etc/ssh/sshd_config`
- Add `X11Forwarding yes` and `X11DisplayOffset 10`
- Then restart ssh `sudo systemctl restart ssh`
3. In a new host terminal connect via SSH to X11 `ssh -X -p 4243 user@localhost`
4. In the same terminal run `firefox-esr`
