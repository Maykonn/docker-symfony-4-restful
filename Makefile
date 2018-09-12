.PHONY: install update start stop restart database database-structure jwt-keys

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))
DOCKER_PATH := $(MKFILE_DIR)docker
APP_PATH := $(MKFILE_DIR)app
DOTENV_FILE_PATH := $(APP_PATH)/.env
JWT_KEYS_PATH := $(APP_PATH)/config/jwt

install:
	@echo Building...
	@cd $(DOCKER_PATH); \
	cp ./docker-compose.example.yml ./docker-compose.yml; \
	docker-compose build; \
	cd ../ && cd $(APP_PATH); \
	composer install; \
	cp ./.env.dist ./.env;
	@make jwt-keys --no-print-directory
	@echo Installation successful

update:
	@echo Updating...
	@cd $(DOCKER_PATH); \
	docker-compose build; \
	cd ../ && cd $(APP_PATH); \
	composer update
	@echo Done.

start:
	@echo Starting...
	@cd $(DOCKER_PATH); \
	docker-compose up --build -d
	@echo Done.

stop:
	@echo Stopping...
	@cd $(DOCKER_PATH); \
	docker-compose down
	@echo Done.

restart:
	@echo Restarting...
	@make stop --no-print-directory
	@make start --no-print-directory

# TODO: permit to be executed only in prod environment
database:
	@cd $(DOCKER_PATH); \
	docker exec -it "$$(docker-compose ps | grep "php" | awk '{print $$1}')" bin/console doctrine:database:create

# TODO: permit to be executed only in prod environment
database-structure:
	@cd $(DOCKER_PATH); \
	docker exec -it "$$(docker-compose ps | grep "php" | awk '{print $$1}')" bin/console doctrine:schema:create

# TODO: verify if user input for USER_JWT_PASSPHRASE is greater than 4 and less than 1023 characters
jwt-keys:
	@read -r -p "Set up a JWT passphrase: " USER_JWT_PASSPHRASE; \
	openssl genrsa -passout pass:$$USER_JWT_PASSPHRASE -out $(JWT_KEYS_PATH)/private.pem -aes256 4096; \
	openssl rsa -in $(JWT_KEYS_PATH)/private.pem -passin pass:$$USER_JWT_PASSPHRASE -pubout -out $(JWT_KEYS_PATH)/public.pem; \
	chmod 755 $(JWT_KEYS_PATH)/private.pem; \
	chmod 755 $(JWT_KEYS_PATH)/public.pem; \
	chmod +x $(DOTENV_FILE_PATH); \
	sed -i "s/JWT_PASSPHRASE=.*/JWT_PASSPHRASE=$$USER_JWT_PASSPHRASE/g" $(DOTENV_FILE_PATH);