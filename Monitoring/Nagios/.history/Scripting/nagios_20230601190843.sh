#!/bin/bash/usr env

$USER1$=/usr/lib/nagios/plugins

sudo nano /usr/local/nagios/etc/objects/contacts.cfg
    email                   omaciasnarvaez@gmail.com ; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS ******


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
