.PHONY: install update start stop restart gen-jwt-keys

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))
DOCKER_PATH := $(MKFILE_DIR)docker
APP_PATH := $(MKFILE_DIR)app
DOTENV_FILE_PATH := $(APP_PATH)/.env
JWT_KEYS_PATH := $(APP_PATH)/config/jwt

install:
	@echo Building...
	@cd $(DOCKER_PATH); \
	docker-compose build; \
	cd ../ && cd $(APP_PATH); \
	composer install; \
	cp ./.env.dist ./.env;
	@make gen-jwt-keys --no-print-directory
	@echo Installation successful

update:
	cd $(APP_PATH); \
	composer update

start:
	cd $(DOCKER_PATH); \
	docker-compose up -d

stop:
	cd $(DOCKER_PATH); \
	docker-compose down

restart:
	make stop
	make start

# TODO: verify if user input for USER_JWT_PASSPHRASE is greater than 4 and less than 1023 characters
gen-jwt-keys:
	@read -r -p "Set up a JWT passphrase: " USER_JWT_PASSPHRASE; \
	openssl genrsa -passout pass:$$USER_JWT_PASSPHRASE -out $(JWT_KEYS_PATH)/private.pem -aes256 4096; \
	openssl rsa -in $(JWT_KEYS_PATH)/private.pem -passin pass:$$USER_JWT_PASSPHRASE -pubout -out $(JWT_KEYS_PATH)/public.pub; \
	chmod +x $(DOTENV_FILE_PATH); \
	sed -i "s/JWT_PASSPHRASE=.*/JWT_PASSPHRASE=$$USER_JWT_PASSPHRASE/g" $(DOTENV_FILE_PATH);