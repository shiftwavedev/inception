DOCKER_COMPOSE = docker compose -f srcs/docker-compose.yml

all:
	$(DOCKER_COMPOSE) up -d --build

re: fclean all

clean:
	$(DOCKER_COMPOSE) down -v

fclean: clean
	docker system prune --all


.PHONY: all clean fclean re