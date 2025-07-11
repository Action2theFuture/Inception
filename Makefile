OS := $(shell uname)
USER_PATH := $(HOME)
DATA_PATH := $(HOME)/data

all: up

init:
	@sudo chmod +x ./scripts/init_inception.sh
	@./scripts/init_inception.sh

up: init
	@echo "Starting Docker containers..."
	docker-compose -f srcs/docker-compose.yml up --build -d

down:
	@echo "Stopping Docker containers..."
	docker-compose -f srcs/docker-compose.yml down

restart:
	@echo "Restarting Docker containers..."
	docker-compose -f srcs/docker-compose.yml restart

delete:
	@sudo rm -rf $(DATA_PATH)

clean:
	@echo "Cleaning up Docker system..."
	@docker-compose -f srcs/docker-compose.yml down -v --remove-orphans --rmi all
	@docker network prune
	
fclean: clean
	@echo "Full Cleaning up Docker system"
	@sudo rm -rf $(DATA_PATH)
	@sudo docker system prune -a -f;

.PHONY: init all build up down restart clean delete fclean
