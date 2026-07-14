*This project has been created as part of the 42 curriculum by thblack -*
# hive_inception #
### inception project for Hive, Helsinki ###

## Description ##
*Presentation, goal and overview*
The entire project is built inside a virutal machine. For this I chose Debian as had the most complete documentation, file size was not a deciding factor and lastly because most Docker documentation assumes Debian or Ubuntu.

N.B. `docker compose` is used NOT `docker-compose` the difference being that former is the modern tool built with GO and the latter is an older, now deprecated tool built with Python.

Docker is used to setup and manage services in containers that reproduce conditions of independent running. A further layer on top of docker is the use of docker compose and a docker-compose.yml file to orchestrate the setup and running of these containers and services.

Each container builds from an image, in this case Debian 12 Bookworm (the penultimate stable release) which by default is downloaded from Docker Hub, the default registry. Within each container services are then installed mostly by `apt` with the notable exception of WP-CLI which is installed directly from the GitHub repository.

### Virtual Machines vs Docker ###
Virtual Machines (VMs) are abstractions of entire computers in both software and hardware. They allow the user to specify things such as processors, RAM, display, I/O and storage as well as install software inside that environment. The abstraction is run inside another host operating system. By contrast docker is a management system for containers. A container shares hardware resources with the host machine dynamically and also shares some of the same kernel as the host when run on Linux machines. Meanwhile the containers still run independently and require the use of a docker network in order to interact with one another. The result is that containers have many of the benefits of VMs but are much more lightweight

### Secrets vs Environment Variables ###
Secrets are sensitive information such as passwords or encryption keys whereas environment variables are often used for configuration settings and are stored as key-value pairs.

### Docker Network vs Host Network ###
Thses are two networking modes in Docker. Docker network allows containers to interact with one another while maintaining isolation for containers. Whereas Host network uses the host's IP address anad is generally less secure.

### Docker Volumes vs Bind Mounts ###
Docker volumes and bind mounts are two ways of storing data in a docker setup. With a docker volume, docker handles the volume entirely and the user can interact via the API. The volume can also be mounted by the user locally. By contrast a bind mount is stored anywhere on the host computer and a route to that is provided in the docker configuration.

## Instructions ##
How to start and stop the project
1. Clone the repository and navgate to project root `git clone <repo url> && cd <repo name>`
2. Create a .env file at srcs/.env ([see Credentials](#Credentials))
3. Build and launch `make up`
4. Access the website (optional) ([see Website & Admin Panel](#Website-&-Admin-Panel))
5. Stop the project `make down` or to wipe `make fclean`
N.B. For instructions specific to inception within a virtual machine see USER_DOC.md

## Resources ##
List of references to the topic
[Basic Docker Guide](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)

## AI Usage ##
AI was used at three stages of this project, in the initial design, in drafting of the dockerfiles and scripts and finally in the debugging stage. AI usage was entirely with a ChatBot. The decision to avoid agentic-AI or IDE-integration was a conscious one to introduce more friction to the process and encourage more independent analysis, interaction with the tech-stack, problem-solving and comprehension.

## Optional Extras ##
Usage examples, feature list, technical choices
