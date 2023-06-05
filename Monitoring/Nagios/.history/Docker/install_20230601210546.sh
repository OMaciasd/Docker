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

sudo echo cfg_file=/usr/local/nagios/etc/objects/linux.cfg >> /usr/local/nagios/etc/nagios.cfg
sudo echo cfg_dir=/usr/local/nagios/etc/servers >> /usr/local/nagios/etc/nagios.cfg

sudo echo define command{ >> /usr/local/nagios/etc/objects/commands.cfg
sudo echo    command_name check_nrpe >> /usr/local/nagios/etc/objects/commands.cfg
sudo echo    command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$ >> /usr/local/nagios/etc/objects/commands.cfg
sudo echo } >> /usr/local/nagios/etc/objects/commands.cfg

sudo echo define command { >> /usr/local/nagios/etc/objects/commands.cfg >> /usr/local/nagios/etc/objects/commands.cfg
sudo echo    command_name    check_traceroute >> /usr/local/nagios/etc/objects/commands.cfg
sudo echo    command_line    /usr/sbin/traceroute -n -T -p $ARG2$ $HOSTADDRESS$ >> /usr/local/nagios/etc/objects/commands.cfg
sudo echo } >> /usr/local/nagios/etc/objects/commands.cfg

# Host Services.
cd usr/local/nagios/etc/objects/
sudo touch linux.cfg


exit
