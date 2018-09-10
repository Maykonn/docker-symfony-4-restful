.PHONY: install update start stop restart

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))

APP_PATH=$(MKFILE_DIR)app
DOTENV_FILE_PATH=$(APP_PATH)/.env
JWT_KEYS_PATH=$(APP_PATH)/config/jwt

#echo $(DOTENV_FILE_PATH)
#export $(cat ./app/.env | grep -v ^# | xargs)
#echo ${JWT_PASSPHRASE}
#sudo -s && source $(DOTENV_FILE_PATH) && echo "my secret key is: " $$JWT_PASSPHRASE

test:
	@cd $(APP_PATH) \
	@chmod +x $(DOTENV_FILE_PATH).env; \
	read -r -p "Enter jwt passphrase: " secret; \
	echo "$$secret"; \
    sed -i "s/JWT_PASSPHRASE=.*/JWT_PASSPHRASE=$$secret/g" $(DOTENV_FILE_PATH)

install:
	cd docker; \
	docker build; \
	cd app; \
	composer install; \
	cp ./.env.dist ./.env; \
	chmod +x .env; \
	@read -p "Enter jwt passphrase:" JWT_PASSPHRASE; \
    sed -i 's/JWT_PASSPHRASE=*/JWT_PASSPHRASE=$$JWT_PASSPHRASE/g' .env

	#source $(APP_PATH)/.env && echo "my secret key is: $$JWT_PASSPHRASE"

update:
	cd app && composer update

start:
	cd docker && docker-compose up

stop:
	cd docker && docker-compose down

restart:
	make stop
	make start

gen-jwt-keys:
	cd app; \
	@while [ -z "$$SECRET" ]; do \
        read -r -p `openssl genrsa -out config/jwt/private.pem -aes256 4096` SECRET; \
    done ; \
    echo massa "$$SECRET"



#	@echo 'teste: '
#	@read -r -p "Enter jwt passphrase: " test; \
#	echo massa "$$test"
#
#	cd app; \
#    read -r -p `openssl genrsa -out config/jwt/private.pem -aes256 4096` secret secretconfirm; \
#    echo $secret; \
#    echo $secretconfirm;

#	@read -p "Enter Module Name:" module; \
#    module_dir=./modules/$$module; \
#    mkdir -p $$module_dir/build