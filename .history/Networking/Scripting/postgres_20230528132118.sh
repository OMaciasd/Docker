#!/bin/bash/usr env

sudo apt update
yes | sudo apt upgrade

sudo apt install postgresql postgresql-contrib

sudo su - postgres

psql
\l
create user curso with password 'Postgres2023.';
create database db_curso with owner curso;

alter user curso with superuser;

sudo apt install curl

curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add

sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

sudo apt install pgadmin4
