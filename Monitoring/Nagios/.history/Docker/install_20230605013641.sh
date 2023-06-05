#!/bin/sh

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
                        nmap \
                        traceroute \
                        ufw \
                        net-tools \
                        apache2 \
                        monitoring-plugins \
                        nagios-nrpe-plugin;

tar -xf nagioscore-nagios-4.4.6.tar.gz;
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

mkdir -p /usr/local/nagios/etc/servers;

{
echo cfg_file=/usr/local/nagios/etc/objects/linux.cfg
define command ;{
   command_name check_nrpe
   command_line "$USER1$"/check_nrpe -H "$HOSTADDRESS$" -c "$ARG1$"
}
} >> /usr/local/nagios/etc/objects/etc/nagios.cfg

{
echo define command ;{
   command_name check_nrpe
   command_line "$USER1$"/check_nrpe -H "$HOSTADDRESS$" -c "$ARG1$"
}
} >> /usr/local/nagios/etc/objects/commands.cfg

nano /usr/local/nagios/etc/resource.cfg
# $USER1$=/usr/lib/nagios/plugins

nano /usr/local/nagios/etc/objects/contacts.cfg

# Templates.
nano /usr/local/nagios/etc/objects/templates.cfg

service nagios restart;

service apache2 restart;

# yes | apt install php libapache2-mod-php;

exit
