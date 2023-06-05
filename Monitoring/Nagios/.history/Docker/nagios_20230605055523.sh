#!/bin/bash/usr env

yes | apt upgrade;
    yes | apt update;
    yes | apt autoremove;
    yes | apt install php \
        libapache2-mod-php;
wget https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz;
    tar -xf nagios-4.4.6.tar.gz;
    cd nagioscore-nagios-4.4.6/ || exit;
    ./configure --with-httpd-conf=/etc/apache2/sites-enabled;
    make all;
    make install-groups-users;
    usermod -a -G nagios www-data;
    make install;
    make install-daemoninit;
    make install-commandmode;
    make install-config;
    make install-webconf;
    a2enmod rewrite cgi;
    service apache2 restart;
    htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin;
    ufw allow apache;
    echo y | ufw enable;
    ufw reload;
    ufw status;
yes | apt install monitoring-plugins nagios-nrpe-plugin;
mkdir -p /usr/local/nagios/etc/servers;
nano /usr/local/nagios/etc/nagios.cfg
cfg_file=/usr/local/nagios/etc/objects/linux.cfg
cfg_dir=/usr/local/nagios/etc/servers

nano /usr/local/nagios/etc/resource.cfg
$USER1$=/usr/lib/nagios/plugins

nano /usr/local/nagios/etc/objects/contacts.cfg
    email                   omaciasnarvaez@gmail.com ; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS ******

# Commands.
nano /usr/local/nagios/etc/objects/commands.cfg
define command{
    command_name check_nrpe
    command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}

define command {
    command_name    check_traceroute
    command_line    /usr/sbin/traceroute -n -T -p $ARG2$ $HOSTADDRESS$
}

# Templates.
nano /usr/local/nagios/etc/objects/templates.cfg
        check_interval   1

# Host Services.
nano /usr/local/nagios/etc/objects/linux.cfg
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

nano /root/.bashrc
alias nagioscheck='/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg'
alias nagiosreload='service nagios restart'

su
source /root/.bashrc
nagioscheck
exit

service nagios start
service apache2 restart

http://localhost:8080/nagios/

su
nagiosreload
exit

exit
