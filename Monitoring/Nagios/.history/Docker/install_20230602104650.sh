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

echo "cfg_file=/usr/local/nagios/etc/objects/linux.cfg" >> /usr/local/nagios/etc/nagios.cfg
echo "cfg_dir=/usr/local/nagios/etc/servers" >> /usr/local/nagios/etc/nagios.cfg

echo "define command {" >> /usr/local/nagios/etc/objects/commands.cfg
echo "   command_name check_nrpe" >> /usr/local/nagios/etc/objects/commands.cfg
echo "   command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$" >> /usr/local/nagios/etc/objects/commands.cfg
echo "}" >> /usr/local/nagios/etc/objects/commands.cfg

echo "define command {" >> /usr/local/nagios/etc/objects/commands.cfg" >> /usr/local/nagios/etc/objects/commands.cfg
echo "   command_name    check_traceroute" >> /usr/local/nagios/etc/objects/commands.cfg
echo "   command_line    /usr/sbin/traceroute -n -T -p $ARG2$ $HOSTADDRESS$" >> /usr/local/nagios/etc/objects/commands.cfg
echo "}" >> /usr/local/nagios/etc/objects/commands.cfg

# Host Services.
echo "define host {" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       use              linux-server" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       host_name        ubuntu" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       alias            Linux_Ubuntu" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       address          10.0.0.11" >> /usr/local/nagios/etc/objects/linux.cfg
echo "}" >> /usr/local/nagios/etc/objects/linux.cfg

echo "define host {" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       use              linux-server" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       host_name        ubuntu2" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       alias            Linux_Ubuntu_2" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       address          10.0.0.12" >> /usr/local/nagios/etc/objects/linux.cfg
echo "}" >> /usr/local/nagios/etc/objects/linux.cfg

echo "define host {" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       use              linux-server" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       host_name        dns2" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       alias            DNS_Ubuntu_2" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       address          8.8.8.8" >> /usr/local/nagios/etc/objects/linux.cfg
echo "}" >> /usr/local/nagios/etc/objects/linux.cfg

echo "define service {" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       use                     generic-service" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       host_name               ubuntu" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       service_description     Hard_Disk" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       check_command           check_nrpe!check_hda1" >> /usr/local/nagios/etc/objects/linux.cfg
echo "}" >> /usr/local/nagios/etc/objects/linux.cfg

echo "define service {" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       use                     generic-service" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       host_name               ubuntu" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       service_description     Ping" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       check_command           check_ping!500.0,20%!800.0,60%" >> /usr/local/nagios/etc/objects/linux.cfg
echo "}" >> /usr/local/nagios/etc/objects/linux.cfg

echo "define service {" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       use                     generic-service" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       host_name               ubuntu" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       service_description     traceroute" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       check_command           check_traceroute!10.0.0.11!22" >> /usr/local/nagios/etc/objects/linux.cfg
echo "}" >> /usr/local/nagios/etc/objects/linux.cfg

echo "'define service {'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'       use                     generic-service'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'       host_name               ubuntu2'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'       service_description     traceroute'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'       check_command           check_traceroute!10.0.0.12!22'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'}'" >> /usr/local/nagios/etc/objects/linux.cfg

echo "'define service {'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'       use                     generic-service'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'      host_name               ubuntu2'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'       service_description     Puerto'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'       check_command           check_tcp!22'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'}'" >> /usr/local/nagios/etc/objects/linux.cfg

echo "'define service {'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'       use                     generic-service'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'       host_name               ubuntu'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'      service_description     Puerto'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'      check_command           check_tcp!22'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'}'" >> /usr/local/nagios/etc/objects/linux.cfg

echo "'define service {" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'       use                     generic-service" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'       host_name               dns2'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'       service_description     DNS'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'       check_command           check_tcp!53'" >> /usr/local/nagios/etc/objects/linux.cfg
echo "'}'" >> /usr/local/nagios/etc/objects/linux.cfg

echo "define service {" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       use                     generic-service" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       host_name               dns2" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       service_description     Puerto" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       check_command           check_tcp!443" >> /usr/local/nagios/etc/objects/linux.cfg
echo "}" >> /usr/local/nagios/etc/objects/linux.cfg

echo "define service {" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       use                     generic-service" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       host_name               ubuntu" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       service_description     Apache2" >> /usr/local/nagios/etc/objects/linux.cfg
echo "       check_command           check_tcp!80" >> /usr/local/nagios/etc/objects/linux.cfg
echo "}" >> /usr/local/nagios/etc/objects/linux.cfg

echo "alias nagioscheck="/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg"" >> /root/.bashrc
echo "alias nagiosreload='service nagios restart'" >> /root/.bashrc

nano /usr/local/nagios/etc/resource.cfg
# $USER1$=/usr/lib/nagios/plugins

nano /usr/local/nagios/etc/objects/contacts.cfg

# Templates.
nano /usr/local/nagios/etc/objects/templates.cfg

service nagios restart;

service apache2 restart;

# yes | apt install php libapache2-mod-php;

exit
