# Docker-Symfony-4-RESTful
This project is all you need to start simply and fastly your new RESTful APIs using Symfony 4. This stack uses Docker
and Makefile to create an easy maintenance cycle for your REST API.

## Installing and starting your RESTful API
1) Just clone this repository with:
```
git clone https://github.com/Maykonn/docker-symfony-4-restful.git
```

2) Go to your `hosts` file and add `app.localhost`:
```
127.0.0.1   app.localhost
```

3) Execute the following command to install and build the Docker image (you will be asked to provide a JWT 
secret, you can type what you prefer):
```
make install
```

4) Create the database and database structure executing:
```
make database
make database-structure
```

5) And start your API:
```
make start
```

## Using the initial provided API
The initial api code provided by this bundle is an authentication API for Symfony 4 using a JWT approach, below are listed
all initial routes provided:  

`POST > http://app.localhost:8080/register` (json body example):  
```JSON
{
	"username": "my-username",
	"password": "123456"
}
```

`POST > http://app.localhost:8080/login_check` (json body example):  
```JSON
{
	"username": "my-username",
	"password": "123456"
}
```

`GET > http://app.localhost:8080/api` (Authorization Header is required for all protected routes):  
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ik1heWtvbm4iLCJpYXQiOjE1MTYyMzkwMjJ9.b7rMHdFlAixTQA6DzLoHIjw3MrRtkbm3tuUr_zgXhmE
```

## What to do next?
A pretty basic API is provided by this project and now you can start creating your own resources to your API with new
controllers, models, repositories, services, whatever you need.

## About make commands:
The Makefile is here to keep the management of your API as simple as possible avoiding confuse commands. 

- `make install`: to install and build the project
- `make update`: to update the project dependencies
- `make start`: to start the API
- `make stop`: to stop the API
- `make restart`: to stop and then start again the API
- `make database`: to create the database
- `make database-structure`: to create the database structure (tables, etc.)
- `make jwt-keys`: to create the public and private keys to protect your routes with JWT, the `make install` uses this command

Read more about `make` here: https://www.gnu.org/software/make/ 