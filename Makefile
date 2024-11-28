OS := $(shell uname)
USER_PATH := $(HOME)

ifeq ($(OS), Linux)
    DATA_PATH := $(USER_PATH)/data
    DB_DATA_PATH := $(USER_PATH)/data/db_data
    WORDPRESS_FILES_PATH := $(USER_PATH)/data/wordpress_files
else ifeq ($(OS), Darwin)
    DATA_PATH := $(USER_PATH)/data
    DB_DATA_PATH := $(USER_PATH)/data/db_data
    WORDPRESS_FILES_PATH := $(USER_PATH)/data/wordpress_files
endif

export DATA_PATH

.PHONY: init all build up down restart clean

all: build up

init:
	@mkdir -p $(DB_DATA_PATH)
	@mkdir -p $(WORDPRESS_FILES_PATH)
	@sudo chown -R $(whoami):staff $(DATA_PATH)
	@sudo chmod -R 755 $(DATA_PATH)
	@sudo chown -R $(whoami):staff $(DB_DATA_PATH)
	@sudo chmod -R 755 $(DB_DATA_PATH)
	@sudo chown -R $(whoami):staff $(WORDPRESS_FILES_PATH)
	@sudo chmod -R 755 $(WORDPRESS_FILES_PATH)
	@sudo chmod +x ./scripts/update_env.sh
	@./scripts/update_env.sh $(DATA_PATH) $(DB_DATA_PATH) $(WORDPRESS_FILES_PATH)

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
