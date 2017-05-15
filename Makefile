DOCKER ?= docker
DOCKER_COMPOSE ?= docker-compose


all: build

# Docker related commands
up: build-app
	$(DOCKER_COMPOSE) up -d --build api

down:
	$(DOCKER_COMPOSE) down

migrate:
	$(DOCKER) exec bookapi_api_1 npm run knex migrate:latest

build-deps:
	$(DOCKER) build -t bookapi-dependencies -f Dockerfile.dependencies .

build-app:
	$(DOCKER) build -t bookapi -f Dockerfile.app .

build: build-deps build-app

# General utilities
clean-db:
	sudo rm -rf ./pgdata

clean: clean-db
	rm -rf node_modules npm-debug.log

.PHONY: up, down, migrate; build-deps, build-app, build, clean-db, clean
