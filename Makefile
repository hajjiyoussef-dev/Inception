NAME = inception

COMPOSE = docker compose -f ./srcs/docker-compose.yml

all: up

up:
	$(COMPOSE) up --build -d

down:
	$(COMPOSE) down

start:
	$(COMPOSE) start

stop:
	$(COMPOSE) stop

restart: down up

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

clean:
	$(COMPOSE) down -v

fclean:
	$(COMPOSE) down --rmi all -v
	docker system prune -af

re: fclean up

.PHONY: all up down start stop restart logs ps clean fclean re