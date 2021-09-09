#!/bin/bash
# sndo ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

sudo service php8.0-fpm start
sudo service nginx start
sudo service mysql start
sudo service redis-server start

# SUDO_FORCE_REMOVE=yes sudo apt-get purge -y sudo

/bin/bash # get into container
