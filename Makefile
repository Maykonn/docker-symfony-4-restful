.PHONY: install update start stop restart jwt-keys database database-structure database-structure-update

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))
DOCKER_PATH := $(MKFILE_DIR)docker
APP_PATH := $(MKFILE_DIR)app
DOTENV_FILE_PATH := $(APP_PATH)/.env
JWT_KEYS_PATH := $(APP_PATH)/config/jwt

define get_env
	$$(grep APP_ENV $(DOTENV_FILE_PATH) | cut -d '=' -f2)
endef

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

# TODO: verify if user input for USER_JWT_PASSPHRASE is greater than 4 and less than 1023 characters
jwt-keys:
	@read -r -p "Set up a JWT passphrase: " USER_JWT_PASSPHRASE; \
	openssl genrsa -passout pass:$$USER_JWT_PASSPHRASE -out $(JWT_KEYS_PATH)/private.pem -aes256 4096; \
	openssl rsa -in $(JWT_KEYS_PATH)/private.pem -passin pass:$$USER_JWT_PASSPHRASE -pubout -out $(JWT_KEYS_PATH)/public.pem; \
	chmod 755 $(JWT_KEYS_PATH)/private.pem; \
	chmod 755 $(JWT_KEYS_PATH)/public.pem; \
	chmod +x $(DOTENV_FILE_PATH); \
	sed -i "s/JWT_PASSPHRASE=.*/JWT_PASSPHRASE=$$USER_JWT_PASSPHRASE/g" $(DOTENV_FILE_PATH);

database:
ifeq ($(force),1)
	@cd $(DOCKER_PATH); \
	docker exec -it "$$(docker-compose ps | grep "php" | awk '{print $$1}')" bin/console doctrine:database:create
else ifeq ($(shell [ $(call get_env) = dev ] && echo true),true)
	@cd $(DOCKER_PATH); \
	docker exec -it "$$(docker-compose ps | grep "php" | awk '{print $$1}')" bin/console doctrine:database:create
else
	@echo Recipe enabled only for \"dev\" environment, see $(DOTENV_FILE_PATH) file.
	@echo If are you aware about the risks run as \`make database force=1\`.
endif

database-structure:
ifeq ($(force),1)
	@cd $(DOCKER_PATH); \
	docker exec -it "$$(docker-compose ps | grep "php" | awk '{print $$1}')" bin/console doctrine:schema:create
else ifeq ($(shell [ $(call get_env) = dev ] && echo true),true)
	@cd $(DOCKER_PATH); \
	docker exec -it "$$(docker-compose ps | grep "php" | awk '{print $$1}')" bin/console doctrine:schema:create
else
	@echo Recipe enabled only for \"dev\" environment, see $(DOTENV_FILE_PATH) file.
	@echo If are you aware about the risks run as \`make database-structure force=1\`.
endif

database-structure-update:
ifeq ($(force),1)
	@cd $(DOCKER_PATH); \
	docker exec -it "$$(docker-compose ps | grep "php" | awk '{print $$1}')" bin/console doctrine:schema:update
else ifeq ($(shell [ $(call get_env) = dev ] && echo true),true)
	@cd $(DOCKER_PATH); \
	docker exec -it "$$(docker-compose ps | grep "php" | awk '{print $$1}')" bin/console doctrine:schema:update
else
	@echo Recipe enabled only for \"dev\" environment, see $(DOTENV_FILE_PATH) file.
	@echo If are you aware about the risks run as \`make database-structure force=1\`.
endif