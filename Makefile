DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml

all: setup-volumes
	$(DOCKER_COMPOSE) up -d --build

setup-volumes:
	@echo "Creating volume directories..."
	@mkdir -p $$(grep '^LOGIN=' srcs/.env | cut -d'=' -f2 | xargs -I {} echo /home/{}/data/mariadb)
	@mkdir -p $$(grep '^LOGIN=' srcs/.env | cut -d'=' -f2 | xargs -I {} echo /home/{}/data/wordpress)
	@echo "[INFO] Volume directories ready"

re: fclean all

clean:
	$(DOCKER_COMPOSE) down -v
	@echo "Removing volume directories..."
	@rm -rf $$(grep '^LOGIN=' srcs/.env | cut -d'=' -f2 | xargs -I {} echo /home/{}/data)
	@echo "[INFO] Volume directories removed"

fclean: clean
	docker system prune --all

# Optional rules

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

stop:
	$(DOCKER_COMPOSE) stop

start:
	$(DOCKER_COMPOSE) start

restart:
	$(DOCKER_COMPOSE) restart

logs:
	$(DOCKER_COMPOSE) logs -f

ps:
	$(DOCKER_COMPOSE) ps

build:
	$(DOCKER_COMPOSE) build

pull:
	$(DOCKER_COMPOSE) pull

exec-nginx:
	$(DOCKER_COMPOSE) exec nginx sh

exec-wordpress:
	$(DOCKER_COMPOSE) exec wordpress sh

exec-mariadb:
	$(DOCKER_COMPOSE) exec mariadb sh

validate:
	$(DOCKER_COMPOSE) config

prune-volumes:
	docker volume prune -f

prune-images:
	docker image prune -a -f

health:
	@echo "==> Container Health Status:"
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

stats:
	docker stats --no-stream

.PHONY: all clean fclean re setup-volumes up down stop start restart logs ps build pull \
        exec-nginx exec-wordpress exec-mariadb validate prune-volumes \
        prune-images health stats
