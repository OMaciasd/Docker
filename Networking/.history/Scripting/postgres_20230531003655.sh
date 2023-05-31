#!/bin/bash/usr env

# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-20-04-es

sudo apt update
yes | sudo apt upgrade
sudo apt install \
    postgresql \
    postgresql-contrib \
    net-tools \
    curl \
    nmap

sudo su - postgres

psql

\l

create user postgres with password 'postgres';

create database postgres with owner postgres;

alter user postgres with superuser;

\q
exit

exit

curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add

sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

sudo apt install pgadmin4 -y
