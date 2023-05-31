#!/bin/bash/usr env

# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-20-04-es
https://enterprise.arcgis.com/es/server/10.4/cloud/amazon/change-default-database-passwords-on-linux.htm#:~:text=Inicie%20sesi%C3%B3n%20en%20psql%20con,la%20base%20de%20datos%20postgres.&text=Emita%20el%20comando%20%5Cpassword%20para,es%20%5Cpassword%20
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
