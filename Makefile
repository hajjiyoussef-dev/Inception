NAME = inception


WP_DATA = /home/yhajji/data/wordpress
DB_DATA = /home/yhajji/data/mariadb

COMPOSE = docker compose -f ./srcs/docker-compose.yml

all: up

up:
	@mkdir -p $(WP_DATA) $(DB_DATA)
	$(COMPOSE) up --build 

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
	@sudo rm -rf $(WP_DATA) $(DB_DATA)
	$(COMPOSE) down --rmi all -v
	docker system prune -af

re: fclean up

.PHONY: all up down start stop restart logs ps clean fclean re