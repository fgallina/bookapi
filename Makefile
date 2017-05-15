DOCKER ?= docker
DOCKER_COMPOSE ?= docker-compose
KUBECTL ?= kubectl


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

# Kubernetes related commands
kube-build:
	./scripts/build-images-in-minikube.sh

kube-deploy: kube-build
	$(KUBECTL) apply -f deploy/

kube-migrate:
	./scripts/run-migrate-in-pod.sh

kube-delete:
	$(KUBECTL) delete -f deploy/

# General utilities
clean-db:
	sudo rm -rf ./pgdata

clean: clean-db
	rm -rf node_modules npm-debug.log


.PHONY: up, down, migrate; build-deps, build-app, build, kube-build, kube-deploy, kube-migrate, kube-delete, clean-db, clean
