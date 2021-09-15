#!/bin/bash
name_tag='my_lemp:latest'
TZ='Asia/Taipei'
USER="$(whoami)"
MYSQL_ROOT_PASSWORD='password'

sudo docker build \
    -f Dockerfile \
    -t $name_tag \
    --build-arg TZ=$TZ \
    --build-arg USER=$USER \
    --build-arg MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
    ./


nginx_conf_file="$PWD/nginx.conf"

sudo docker run \
    --rm \
    -it \
    --name my_lemp \
    -p 80:80 \
    -v "$nginx_conf_file:/etc/nginx/sites-available/default" \
    -v "$PWD/src:/var/www/html" \
    -v "laravel_mariadb:/var/lib/mysql" \
    $name_tag
