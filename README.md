# Docker Symfony 4 RESTful
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

4) Create the database and database structure:
```
make database
make database-structure
```

5) And start your API:
```
make start
```

## Using the initial provided API
The initial RESTful API code provided by this bundle is an example of a JWT Authentication approach with Symfony 4, 
below are listed all initial routes provided:  

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

## What to do next
A pretty basic API is provided by this project and now you can start creating your own resources to your API with new
controllers, models, repositories, services, whatever you need.

## About make commands
The Makefile is here to keep the management of your API as simple as possible avoiding confuse commands. 

- `make install`: to install and build the project
- `make update`: to update the project dependencies
- `make start`: to start the API
- `make stop`: to stop the API
- `make restart`: to stop and then start again the API
- `make jwt-keys`: to create the public and private keys to protect your routes with JWT, the `make install` uses this command
- `make database`: to create the database
- `make database-structure`: to create the database structure (tables, etc.)
- `make database-structure-update`: to update the database structure

Read more about `make` here: https://www.gnu.org/software/make/

**OBS:** `make database*` commands will be executed only when in **"dev"** environment.  
If are you aware about the risks use the `force=1` param, example:
```
make database-structure-update force=1
```

# Community Support
If you need help with this bundle please consider [open a question on StackOverflow](https://stackoverflow.com/questions/ask)
using the `docker-symfony-4-restful` tag, it is the official support platform for this bundle.

Github Issues are dedicated to bug reports and feature requests.

# Contributing
You can contribute to this project cloning this repository in your clone you just need to create a new branch using a 
name related to the new functionality which you'll create.  
When you finish your work, you just need to create a pull request which will be revised, merged to master branch (if the code 
doesn't break the project) and published as a new release.
