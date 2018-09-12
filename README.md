# Docker-Symfony-4-RESTful
This project is all you need to start simply and fastly your new RESTful APIs using Symfony 4. This stack uses Docker
and Makefile to create an easily maintenance cycle for your REST API.

## Installing and starting your RESTful API
1) Just clone this repository with:
```
git clone https://github.com/Maykonn/docker-symfony-4-restful.git
```

2) Go to your hosts file and add app.localhost:
```
127.0.0.1   app.localhost
```

3) Execute the following command to install the build the Docker image (you will be asked by a JWT 
secret, you can type what you prefer):
```
make install
```

4) Creating the database and database structure:
```
make database 
make database-structure
```

5) Start your API with:
```
make start
```

## Using the initial provided API
The initial api code provided by this bundle is an authentication api for Symfony 4 using a JWT approach, bellow are listed
all initial routes provided:  

POST > http://app.localhost:8080/register (json body example):  
```JSON
{
	"username": "my-username",
	"password": "123456"
}
```

POST > http://app.localhost:8080/login_check (json body example):  
```JSON
{
	"username": "my-username",
	"password": "123456"
}
```

GET > http://app.localhost:8080/api (Authorization Header is required):  
`Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ik1heWtvbm4iLCJpYXQiOjE1MTYyMzkwMjJ9.b7rMHdFlAixTQA6DzLoHIjw3MrRtkbm3tuUr_zgXhmE`