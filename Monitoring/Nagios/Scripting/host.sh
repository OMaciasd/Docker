#!/bin/bash/usr env

yes | sudo apt upgrade
    yes | sudo apt update
    yes | sudo apt autoremove

apt-cache search nrpe
    yes | sudo apt-get install nagios-nrpe-server nagios-plugins-basic nagios-plugins

sudo service nagios-nrpe-server start
    service nagios-nrpe-server status
    service nagios-nrpe-server enable

sudo nano /etc/nagios/nrpe.cfg
allowed_hosts=127.0.0.1,::1,10.0.0.10
dont_blame_nrpe=1

sudo service nagios-nrpe-server restart
