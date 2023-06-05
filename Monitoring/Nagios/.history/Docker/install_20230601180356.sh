#!/bin/bash/usr env

yes | apt update --fix-missing;
        yes | apt upgrade;
        yes | apt autoremove;
        yes | apt install autoconf \
                        bc \
                        gawk \
                        dc \
                        build-essential \
                        gcc \
                        libc6 \
                        make \
                        unzip \
                        libgd-dev \
                        libmcrypt-dev \
                        libssl-dev \
                        snmp \
                        libnet-snmp-perl \
                        gettext \
                        nano \
                        sudo \
                        nmap \
                        traceroute \
                        ufw \
                        net-tools \
                        apache2 \
                        monitoring-plugins \
                        nagios-nrpe-plugin;

sudo tar -xf nagioscore-nagios-4.4.6.tar.gz;
        cd nagioscore-nagios-4.4.6/ || exit;
        sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled;
                sudo make all;
                        sudo make install-groups-users;
                        sudo usermod -a -G nagios www-data;
                        sudo make install;
                        sudo make install-daemoninit;
                        sudo make install-commandmode;
                        sudo make install-config;
                        sudo make install-webconf;

sudo a2enmod rewrite cgi;
        sudo service apache2 restart;

sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin;

sudo mkdir -p /usr/local/nagios/etc/servers;
sudo nano /usr/local/nagios/etc/nagios.cfg

exit
