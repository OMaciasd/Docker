#!/bin/bash/usr env

ufw allow apache;
    echo y | ufw enable;
    ufw reload;
    ufw status;

/usr/lib/nagios/plugins/check_tcp -H DIRECCION_IP_O_HOSTNAME -p PUERTO
