ifneq ($(wordlist 2,2,$(MAKECMDGOALS)),)

  # Use the rest as arguments for target commands
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

  # ...and turn them into do-nothing targets
  $(eval $(PROJECT) $(RUN_ARGS):;@:)
endif

.PHONY: help

build: ## Run 'docker-compose build to build container image, ...
	@echo "running 'docker-compose build'"
	@docker-compose build

up: ## Run 'docker-compose up -d' to run nginx on localhost:8080 ...
	@echo "running 'docker-compose up -d'"
	@docker-compose up -d

down: stop ## Run 'docker-compose down -v' to cleanup containers, networks (if any, including default). Networks and volumes defined as `external` are never removed.
	@echo "running 'docker-compose down -v'"
	@docker-compose down -v

convert: ## Run 'docker-compose run gpac /gpac/bin/convert.sh [DIR]' to convert jpeg to heic in given dir (default to images dir)
	@echo "running 'docker-compose run gpac /gpac/bin/convert.sh $(RUN_ARGS)'"
	@docker-compose run gpac /gpac/bin/convert.sh $(RUN_ARGS)

logs: ## Run 'docker-compose logs -f' to show logs
	@echo "running 'docker-compose logs -f'"
	@docker-compose logs -f

stop: ## Run 'docker-compose stop ' to stop all the services defined in docker-compose.yml
	@echo "running 'docker-compose stop'"
	@docker-compose stop

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36mmake %-30s\033[0m %s\n", $$1, $$2}'
	@echo "				       ----------------------------------"

.DEFAULT_GOAL := help

# Query the default goal.
ifeq ($(.DEFAULT_GOAL),)
  $(warning no default goal is set)
endif
