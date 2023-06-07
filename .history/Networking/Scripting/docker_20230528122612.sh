#!/bin/bash/usr env

docker pull ubuntu/postgres:latest

docker images

docker run -d --name postgres-server-vp -p 5433:5432 -v postgres-data:/var/lib/postgresql/data -e "POSTGRES_PASSWORD=postgres123" postgres