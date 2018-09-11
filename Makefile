.PHONY: install update start stop restart gen-jwt-keys

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))
DOCKER_PATH := $(MKFILE_DIR)docker
APP_PATH := $(MKFILE_DIR)app
DOTENV_FILE_PATH := $(APP_PATH)/.env
JWT_KEYS_PATH := $(APP_PATH)/config/jwt

install:
	@cd $(DOCKER_PATH); \
	docker build; \
	cd ../ && cd $(APP_PATH); \
	composer install; \
	cp ./.env.dist ./.env;
	make gen-jwt-keys --no-print-directory

update:
	cd app && composer update

start:
	cd docker && docker-compose up

stop:
	cd docker && docker-compose down

restart:
	make stop
	make start

# TODO: verify if user input for USER_JWT_PASSPHRASE is greater than 4 and less than 1023 characters
gen-jwt-keys:
	@cd $(APP_PATH); \
	read -r -p "Enter jwt passphrase: " USER_JWT_PASSPHRASE; \
	openssl genrsa -passout pass:$$USER_JWT_PASSPHRASE -out config/jwt/private.pem -aes256 4096; \
	chmod +x $(DOTENV_FILE_PATH); \
	sed -i "s/JWT_PASSPHRASE=.*/JWT_PASSPHRASE=$$USER_JWT_PASSPHRASE/g" $(DOTENV_FILE_PATH);