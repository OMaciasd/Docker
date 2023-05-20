#!/bin/bash/usr env

yes | sudo apt upgrade
    yes | sudo apt update
    yes | sudo apt autoremove
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
        snmp \
        libnet-snmp-perl \
        gettext \
        nano \
        ufw \
        php \
        libapache2-mod-php \
        net-tools;
sudo wget https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.6.tar.gz
    sudo tar -xf nagios-4.4.6.tar.gz
    cd nagioscore-nagios-4.4.6/ || exit
    sudo ./configure --with-httpd-conf=/etc/apache2/sites-enabled
    sudo make all
    sudo make install-groups-users
    sudo usermod -a -G nagios www-data
    sudo make install
    sudo make install-daemoninit
    sudo make install-commandmode
    sudo make install-config
    sudo make install-webconf
    sudo a2enmod rewrite cgi
    sudo systemctl restart apache2
    sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
    sudo ufw allow apache
    sudo ufw enable
    sudo ufw reload
    sudo ufw status
yes | sudo apt install monitoring-plugins nagios-nrpe-plugin
<<<<<<< HEAD
<<<<<<< HEAD
sudo mkdir -p /usr/local/nagios/etc/servers
sudo nano /usr/local/nagios/etc/nagios.cfg
cfg_file=/usr/local/nagios/etc/objects/linux.cfg
cfg_dir=/usr/local/nagios/etc/servers

sudo nano resource.cfg
$USER1$=/usr/lib/nagios/plugins

sudo nano /usr/local/nagios/etc/objects/contacts.cfg
    email                   omaciasnarvaez@gmail.com ; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS ******

sudo nano /usr/local/nagios/etc/objects/commands.cfg
define command{
    command_name check_nrpe
    command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}

sudo nano /usr/local/nagios/etc/objects/templates.cfg
        check_interval   1

sudo nano /usr/local/nagios/etc/objects/linux.cfg
define host{
        use              linux-server
        host_name        ubuntu
        alias            Linux_Ubuntu
        address          10.0.0.11
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

sudo su
nano /root/.bashrc
alias nagioscheck='/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg'
alias nagiosreload='systemctl restart nagios'

source .bashrc
nagioscheck

=======
=======
>>>>>>> 7c1f5899eeeae67756b7b47ccec6ada2562fc13e
    cd /usr/local/nagios/etc
    sudo mkdir -p /usr/local/nagios/etc/servers
sudo nano nagios.cfg
    cfg_dir=/usr/local/nagios/etc/servers

sudo nano resource.cfg
    $USER1$=/usr/lib/nagios/plugins

sudo nano objects/contacts.cfg
    email                   omaciasnarvaez@gmail.com ; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS ******

sudo nano objects/commands.cfg
define command{
	command_name check_nrpe
  	command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}

<<<<<<< HEAD
>>>>>>> 7c1f5899eeeae67756b7b47ccec6ada2562fc13e
=======
>>>>>>> 7c1f5899eeeae67756b7b47ccec6ada2562fc13e
sudo systemctl start nagios
sudo systemctl enable nagios
sudo systemctl status nagios
sudo systemctl restart apache2

<<<<<<< HEAD
<<<<<<< HEAD
http://10.0.0.10/nagios/

nagiosreload
=======
https://IP/nagios/
>>>>>>> 7c1f5899eeeae67756b7b47ccec6ada2562fc13e
=======
https://IP/nagios/
>>>>>>> 7c1f5899eeeae67756b7b47ccec6ada2562fc13e
