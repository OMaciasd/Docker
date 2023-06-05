#!/bin/bash/usr env

yes | apt install php \
    libapache2-mod-php;

    sudo make install-daemoninit;
    sudo make install-commandmode;
    sudo make install-config;
    sudo make install-webconf;
    sudo a2enmod rewrite cgi;
    sudo systemctl restart apache2;
    sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin;
    sudo ufw allow apache;
    echo y | sudo ufw enable;
    sudo ufw reload;
    sudo ufw status;
yes | sudo apt install monitoring-plugins nagios-nrpe-plugin;
sudo mkdir -p /usr/local/nagios/etc/servers;
sudo nano /usr/local/nagios/etc/nagios.cfg
cfg_file=/usr/local/nagios/etc/objects/linux.cfg
cfg_dir=/usr/local/nagios/etc/servers

sudo nano /usr/local/nagios/etc/resource.cfg
$USER1$=/usr/lib/nagios/plugins

sudo nano /usr/local/nagios/etc/objects/contacts.cfg
    email                   omaciasnarvaez@gmail.com ; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS ******

# Commands.
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
sudo nano /usr/local/nagios/etc/objects/linux.cfg
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

sudo nano /root/.bashrc
alias nagioscheck='/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg'
alias nagiosreload='systemctl restart nagios'

sudo su
source /root/.bashrc
nagioscheck
exit

sudo systemctl start nagios
sudo systemctl enable nagios
echo q | sudo systemctl status nagios
sudo systemctl restart apache2

http://10.0.0.10/nagios/

sudo su
nagiosreload
exit

exit
