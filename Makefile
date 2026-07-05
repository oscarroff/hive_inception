# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: thblack- <thblack-@student.hive.fi>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/06/21 13:57:36 by thblack-          #+#    #+#              #
#    Updated: 2026/06/21 14:12:27 by thblack-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

COMPOSE = docker compose \
		  -f src/docker-compose.yml \
		  --project-directory srcs

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

build:
	$(COMPOSE) build

logs:
	$(COMPOSE) logs -f

clean:
	$(COMPOSE) down -v

.PHONY: up down build logs clean
