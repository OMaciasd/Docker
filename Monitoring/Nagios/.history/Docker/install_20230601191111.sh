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

sudo nano /usr/local/nagios/etc/objects/commands.cfg

define command{
    command_name check_nrpe
    command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}

define command {
    command_name    check_traceroute
    command_line    /usr/sbin/traceroute -n -T -p $ARG2$ $HOSTADDRESS$
}

# Templates.
sudo nano /usr/local/nagios/etc/objects/templates.cfg
        check_interval   1

# Host Services.
define host{ > usr/local/nagios/etc/objects/linux.cfg
        use              linux-server >> usr/local/nagios/etc/objects/linux.cfg
        host_name        ubuntu >> usr/local/nagios/etc/objects/linux.cfg
        alias            Linux_Ubuntu >> usr/local/nagios/etc/objects/linux.cfg
        address          10.0.0.11 >> usr/local/nagios/etc/objects/linux.cfg
} >> usr/local/nagios/etc/objects/linux.cfg

define host{ >> usr/local/nagios/etc/objects/linux.cfg
        use              linux-server >> usr/local/nagios/etc/objects/linux.cfg
        host_name        ubuntu2 >> usr/local/nagios/etc/objects/linux.cfg
        alias            Linux_Ubuntu_2 >> usr/local/nagios/etc/objects/linux.cfg
        address          10.0.0.12 >> usr/local/nagios/etc/objects/linux.cfg
} >> usr/local/nagios/etc/objects/linux.cfg

define host{ >> usr/local/nagios/etc/objects/linux.cfg
        use              linux-server >> usr/local/nagios/etc/objects/linux.cfg
        host_name        dns2 >> usr/local/nagios/etc/objects/linux.cfg
        alias            DNS_Ubuntu_2 >> usr/local/nagios/etc/objects/linux.cfg
        address          8.8.8.8 >> usr/local/nagios/etc/objects/linux.cfg
}

define service{ >> usr/local/nagios/etc/objects/linux.cfg
        use                     generic-service >> usr/local/nagios/etc/objects/linux.cfg
        host_name               ubuntu >> usr/local/nagios/etc/objects/linux.cfg
        service_description     Hard_Disk >> usr/local/nagios/etc/objects/linux.cfg
        check_command           check_nrpe!check_hda1 >> usr/local/nagios/etc/objects/linux.cfg
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
