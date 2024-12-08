OS := $(shell uname)
USER_PATH := $(HOME)

.PHONY: init all build up down restart clean

all: build up

init:
	@sudo chmod +x ./scripts/init_inception.sh
	@./scripts/init_inception.sh

build: init
	@echo "Building Docker containers..."
	docker-compose -f srcs/docker-compose.yml build --no-cache

up:
	@echo "Starting Docker containers..."
	docker-compose -f srcs/docker-compose.yml up -d

down:
	@echo "Stopping Docker containers..."
	docker-compose -f srcs/docker-compose.yml down -v

restart:
	@echo "Restarting Docker containers..."
	docker-compose -f srcs/docker-compose.yml restart

clean: down
	@echo "Cleaning up Docker system..."
	@rm -rf $(DATA_PATH)
	@if [ -n "$$(sudo docker ps -a -q)" ]; then sudo docker rm -f $$(sudo docker ps -a -q); fi
	@if [ -n "$$(sudo docker images -q)" ]; then sudo docker rmi -f $$(sudo docker images -q); fi
	@if [ -n "$$(sudo docker volume ls -q)" ]; then sudo docker volume prune -f; fi
