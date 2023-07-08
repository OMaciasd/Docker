#!/bin/bash/usr env

docker pull ubuntu/postgres:latest

docker images

docker run -d --name postgres-server -p 5432:5432 -v postgres-data:/var/lib/postgresql/data -e "POSTGRES_PASSWORD=postgres123" ubuntu/postgres
