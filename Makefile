# Makefile for a Docker-compose project

# Use bash shell in Make instead of sh
SHELL := /bin/bash

# Build the containers
build:
	docker-compose build

# Start the containers
up:
	docker-compose up -d

# Stop the containers
down:
	docker-compose down

# Show logs
logs:
	docker-compose logs -f

# Run bash for a specific service (e.g., make bash service=backend)
bash:
	docker-compose exec $(service) bash

# Run migrations (specific for projects with a backend service)
migrate:
	docker-compose exec backend rails db:migrate

# Seed the database (specific for projects with a backend service)
seed:
	docker-compose exec backend rails db:seed

# Restart a specific service (e.g., make restart service=backend)
restart:
	docker-compose restart $(service)

# Remove all containers, networks, and volumes
clean:
	docker-compose down --volumes --remove-orphans

# Remove all unused containers
remove-unused:
	docker container prune -f

.PHONY: build up down logs bash migrate seed restart clean remove-unused
