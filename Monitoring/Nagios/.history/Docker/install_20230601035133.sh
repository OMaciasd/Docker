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
                        apache2 \
                        libgd-dev \
                        libmcrypt-dev \
                        libssl-dev \
                        snmp \
                        libnet-snmp-perl \
                        gettext \
                        nano \
                        ufw \
                        # php \
                        # libapache2-mod-php \
                        # net-tools \
                        # traceroute \
                        nmap \
                        sudo;

exit
