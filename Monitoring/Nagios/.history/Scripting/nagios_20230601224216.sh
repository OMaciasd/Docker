#!/bin/bash/usr env

$USER1$=/usr/lib/nagios/plugins

sudo nano /usr/local/nagios/etc/objects/contacts.cfg
    email                   omaciasnarvaez@gmail.com ; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS ******

# Templates.
sudo nano /usr/local/nagios/etc/objects/templates.cfg
        check_interval   1

sudo nano /root/.bashrc
alias nagioscheck='/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg'
alias nagiosreload='systemctl restart nagios'

sudo su
source /root/.bashrc
nagioscheck
exit

http://10.0.0.10/nagios/

sudo su
nagiosreload
exit

exit