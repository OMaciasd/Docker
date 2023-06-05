#!/bin/bash/usr env

    sudo ufw allow apache;
    echo y | sudo ufw enable;
    sudo ufw reload;
    sudo ufw status;


/usr/lib/nagios/plugins/check_tcp -H DIRECCION_IP_O_HOSTNAME -p PUERTO
