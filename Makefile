.PHONY: install update start stop restart

install:
	cd docker && docker build
	cd app && composer install && cp ./.env.dist ./.env

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
	openssl genrsa -out config/jwt/private.pem -aes256 4096; \
	echo ${ARGS}

#	@read -p "Enter Module Name:" module; \
#    module_dir=./modules/$$module; \
#    mkdir -p $$module_dir/build