#!/bin/bash
name_tag='my_lemp:latest'
MYSQL_ROOT_PASSWORD='password'

sudo docker build \
    -f Dockerfile \
    -t $name_tag \
    --build-arg MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
    ./

php_conf_file='php-fpm.pool.conf'
nginx_conf_file='nginx.conf'

sudo docker run \
    --rm \
    -it \
    --name my_lemp \
    -p 80:80 \
    -v "$PWD/$php_conf_file:/etc/php/8.0/fpm/pool.d/www.conf" \
    -v "$PWD/$nginx_conf_file:/etc/nginx/sites-available/default" \
    -v "$PWD/src:/var/www/html" \
    $name_tag
