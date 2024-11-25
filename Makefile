.PHONY: all build up down restart clean

all: build up

build:
	docker-compose -f src/docker-compose.yml build

up:
	docker-compose -f src/docker-compose.yml up -d

down:
	docker-compose -f src/docker-compose.yml down

restart:
	docker-compose -f src/docker-compose.yml restart

clean: down
	docker system prune -f
