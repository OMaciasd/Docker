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
echo define host{ >> /usr/local/nagios/etc/objects/linux.cfg
echo       use              linux-server >> /usr/local/nagios/etc/objects/linux.cfg
echo        host_name        ubuntu >> /usr/local/nagios/etc/objects/linux.cfg
echo        alias            Linux_Ubuntu >> /usr/local/nagios/etc/objects/linux.cfg
echo        address          10.0.0.11 >> /usr/local/nagios/etc/objects/linux.cfg
echo } >> /usr/local/nagios/etc/objects/linux.cfg

echo define host{ >> /usr/local/nagios/etc/objects/linux.cfg
echo        use              linux-server >> /usr/local/nagios/etc/objects/linux.cfg
echo        host_name        ubuntu2 >> /usr/local/nagios/etc/objects/linux.cfg
echo        alias            Linux_Ubuntu_2 >> /usr/local/nagios/etc/objects/linux.cfg
echo        address          10.0.0.12 >> /usr/local/nagios/etc/objects/linux.cfg
echo } >> /usr/local/nagios/etc/objects/linux.cfg

echo define host{ >> /usr/local/nagios/etc/objects/linux.cfg
echo        use              linux-server >> /usr/local/nagios/etc/objects/linux.cfg
echo        host_name        dns2 >> /usr/local/nagios/etc/objects/linux.cfg
echo        alias            DNS_Ubuntu_2 >> /usr/local/nagios/etc/objects/linux.cfg
echo        address          8.8.8.8 >> /usr/local/nagios/etc/objects/linux.cfg
echo } >> /usr/local/nagios/etc/objects/linux.cfg

echo define service{ >> /usr/local/nagios/etc/objects/linux.cfg
echo        use                     generic-service >> /usr/local/nagios/etc/objects/linux.cfg
echo        host_name               ubuntu >> /usr/local/nagios/etc/objects/linux.cfg
echo        service_description     Hard_Disk >> /usr/local/nagios/etc/objects/linux.cfg
echo        check_command           check_nrpe!check_hda1 >> /usr/local/nagios/etc/objects/linux.cfg
echo } >> /usr/local/nagios/etc/objects/linux.cfg

echo define service{ >> /usr/local/nagios/etc/objects/linux.cfg
echo        use                     generic-service >> /usr/local/nagios/etc/objects/linux.cfg
echo        host_name               ubuntu >> /usr/local/nagios/etc/objects/linux.cfg
echo        service_description     Ping >> /usr/local/nagios/etc/objects/linux.cfg
echo        check_command           check_ping!500.0,20%!800.0,60% >> /usr/local/nagios/etc/objects/linux.cfg
echo } >> /usr/local/nagios/etc/objects/linux.cfg

echo define service{ >> /usr/local/nagios/etc/objects/linux.cfg
echo        use                     generic-service >> /usr/local/nagios/etc/objects/linux.cfg
echo        host_name               ubuntu >> /usr/local/nagios/etc/objects/linux.cfg
echo        service_description     traceroute >> /usr/local/nagios/etc/objects/linux.cfg
echo        check_command           check_traceroute!10.0.0.11!22 >> /usr/local/nagios/etc/objects/linux.cfg
echo } >> /usr/local/nagios/etc/objects/linux.cfg

echo define service{ >> /usr/local/nagios/etc/objects/linux.cfg
echo        use                     generic-service >> /usr/local/nagios/etc/objects/linux.cfg
echo        host_name               ubuntu2 >> /usr/local/nagios/etc/objects/linux.cfg
echo        service_description     traceroute >> /usr/local/nagios/etc/objects/linux.cfg
echo        check_command           check_traceroute!10.0.0.12!22 >> /usr/local/nagios/etc/objects/linux.cfg
echo } >> /usr/local/nagios/etc/objects/linux.cfg

echo define service { >> /usr/local/nagios/etc/objects/linux.cfg
echo        use                     generic-service >> /usr/local/nagios/etc/objects/linux.cfg
echo        host_name               ubuntu2 >> /usr/local/nagios/etc/objects/linux.cfg
echo        service_description     Puerto >> /usr/local/nagios/etc/objects/linux.cfg
echo        check_command           check_tcp!22 >> /usr/local/nagios/etc/objects/linux.cfg
echo } >> /usr/local/nagios/etc/objects/linux.cfg

echo define service { >> /usr/local/nagios/etc/objects/linux.cfg
echo        use                     generic-service >> /usr/local/nagios/etc/objects/linux.cfg
echo        host_name               ubuntu >> /usr/local/nagios/etc/objects/linux.cfg
echo        service_description     Puerto >> /usr/local/nagios/etc/objects/linux.cfg
echo        check_command           check_tcp!22 >> /usr/local/nagios/etc/objects/linux.cfg
echo } >> /usr/local/nagios/etc/objects/linux.cfg

echo define service { >> /usr/local/nagios/etc/objects/linux.cfg
echo        use                     generic-service >> /usr/local/nagios/etc/objects/linux.cfg
echo        host_name               dns2 >> /usr/local/nagios/etc/objects/linux.cfg
echo        service_description     DNS >> /usr/local/nagios/etc/objects/linux.cfg
echo        check_command           check_tcp!53 >> /usr/local/nagios/etc/objects/linux.cfg
} >> /usr/local/nagios/etc/objects/linux.cfg

define service { >> /usr/local/nagios/etc/objects/linux.cfg
       use                     generic-service >> /usr/local/nagios/etc/objects/linux.cfg
       host_name               dns2 >> /usr/local/nagios/etc/objects/linux.cfg
       service_description     Puerto >> /usr/local/nagios/etc/objects/linux.cfg
       check_command           check_tcp!443 >> /usr/local/nagios/etc/objects/linux.cfg
} >> /usr/local/nagios/etc/objects/linux.cfg

define service { >> /usr/local/nagios/etc/objects/linux.cfg
       use                     generic-service >> /usr/local/nagios/etc/objects/linux.cfg
       host_name               ubuntu >> /usr/local/nagios/etc/objects/linux.cfg
       service_description     Apache2 >> /usr/local/nagios/etc/objects/linux.cfg
       check_command           check_tcp!80 >> /usr/local/nagios/etc/objects/linux.cfg
} >> /usr/local/nagios/etc/objects/linux.cfg


exit
