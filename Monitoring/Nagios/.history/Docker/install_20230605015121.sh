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
echo cfg_dir=/usr/local/nagios/etc/servers
} >> /usr/local/nagios/etc/nagios.cfg

{
echo define command ;{
   command_name check_nrpe
   command_line "$USER1$"/check_nrpe -H "$HOSTADDRESS$" -c "$ARG1$"
}

define command ;{
    command_name    check_traceroute
    command_line    /usr/sbin/traceroute -n -T -p "$ARG2$" "$HOSTADDRESS$"
}
} >> /usr/local/nagios/etc/objects/commands.cfg

{
echo define host ;{
        use              linux-server
        host_name        ubuntu
        alias            Linux_Ubuntu
        address          10.0.0.11
}

define host ;{
        use              linux-server
        host_name        ubuntu2
        alias            Linux_Ubuntu_2
        address          10.0.0.12
}

define host ;{
        use              linux-server
        host_name        dns2
        alias            DNS_Ubuntu_2
        address          8.8.8.8
}

define service ;{
        use                     generic-service
        host_name               ubuntu
        service_description     Hard_Disk
        check_command           check_nrpe!check_hda1
}

define service ;{
        use                     generic-service
        host_name               ubuntu
        service_description     Ping
        check_command           check_ping!500.0,20%!800.0,60%
}

define service ;{
        use                     generic-service
        host_name               ubuntu
        service_description     traceroute
        check_command           check_traceroute!10.0.0.11!22
}

define service ;{
        use                     generic-service
        host_name               ubuntu2
        service_description     traceroute
        check_command           check_traceroute!10.0.0.12!22
}

define service ;{
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
} >> /usr/local/nagios/etc/objects/linux.cfg

nano /usr/local/nagios/etc/resource.cfg
# $USER1$=/usr/lib/nagios/plugins

nano /usr/local/nagios/etc/objects/contacts.cfg

# Templates.
nano /usr/local/nagios/etc/objects/templates.cfg

service nagios restart;

service apache2 restart;

# yes | apt install php libapache2-mod-php;

exit
