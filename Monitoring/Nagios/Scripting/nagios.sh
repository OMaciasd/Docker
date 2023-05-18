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

sudo systemctl start nagios
sudo systemctl enable nagios
sudo systemctl status nagios
sudo systemctl restart apache2

https://IP/nagios/
