#!/bin/bash/usr env

yes | sudo apt upgrade;
    yes | sudo apt update;
    yes | sudo apt autoremove;
    yes | sudo apt install autoconf \
        bc \
        gawk \
        dc \
        build-essential \
        gcc \
        libc6 \
        make \
        unzip \
        apache2 \
        libgd-dev \
        libmcrypt-dev \
        libssl-dev \
        libnet-snmp-perl \
        gettext \
        nano \
        ufw \
        php \
        libapache2-mod-php;
    sudo a2enmod rewrite cgi;
    sudo systemctl restart apache2;

http://10.0.0.11

sudo systemctl stop apache2;

apt-cache search nrpe
    yes | sudo apt-get install nagios-nrpe-server nagios-plugins-basic nagios-plugins

sudo service nagios-nrpe-server start
    service nagios-nrpe-server status
    service nagios-nrpe-server enable

sudo nano /etc/nagios/nrpe.cfg
allowed_hosts=127.0.0.1,::1,10.0.0.10
dont_blame_nrpe=1

sudo service nagios-nrpe-server restart
