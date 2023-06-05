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
cd /usr/local/nagios/etc/objects/
pwd
touch linux.cfg
define host{ 
       use              linux-server
       host_name        ubuntu
       alias            Linux_Ubuntu
       address          10.0.0.11
}

define host{
       use              linux-server
       host_name        ubuntu2
       alias            Linux_Ubuntu_2
       address          10.0.0.12
}

define host{
       use              linux-server
       host_name        dns2
       alias            DNS_Ubuntu_2
       address          8.8.8.8
}

define service{
       use                     generic-service
       host_name               ubuntu
       service_description     Hard_Disk
       check_command           check_nrpe!check_hda1
}

define service{
       use                     generic-service
       host_name               ubuntu
       service_description     Ping
       check_command           check_ping!500.0,20%!800.0,60%
}

define service{
       use                     generic-service
       host_name               ubuntu
       service_description     traceroute
       check_command           check_traceroute!10.0.0.11!22
}

define service{
       use                     generic-service
       host_name               ubuntu2
       service_description     traceroute
       check_command           check_traceroute!10.0.0.12!22
}

define service {
       use                     generic-service
       host_name               ubuntu2
       service_description     Puerto
       check_command           check_tcp!22
}

define service {
       use                     generic-service
       host_name               ubuntu
       service_description     Puerto
       check_command           check_tcp!22
}

define service {
       use                     generic-service
       host_name               dns2
       service_description     DNS
       check_command           check_tcp!53
}

define service {
       use                     generic-service
       host_name               dns2
       service_description     Puerto
       check_command           check_tcp!443
}

define service {
       use                     generic-service
       host_name               ubuntu
       service_description     Apache2
       check_command           check_tcp!80
}


exit
