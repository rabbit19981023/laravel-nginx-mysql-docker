FROM ubuntu:latest as base_system

ARG TZ=Asia/Taipei
ARG MYSQL_ROOT_PASSWORD
ARG USER=andrew

# update apt sources
RUN apt-get update && apt-get upgrade -y

# add a new user who can exec commands via sudo without entering password
RUN apt-get install -y sudo
RUN adduser --disabled-password --gecos '' ${USER} \
    && adduser ${USER} sudo \
    && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# set timezone
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata

# install php
RUN apt-get install -y \
    php-fpm \
    php-mysql

# install Nginx Server
RUN apt-get install --no-install-recommends --no-install-suggests -y ca-certificates nginx
COPY ./default.conf /etc/nginx/conf.d/

# install MariaDB Server
RUN apt-get install -y mariadb-server

# mysql_secure_installation auto scripts
RUN apt-get install -y expect
COPY ./mysql_secure_installation.sh /
RUN ./mysql_secure_installation.sh -root-password ${MYSQL_ROOT_PASSWORD} \
    && rm -f ./mysql_secure_installation.sh

# mysql access permissions
RUN adduser ${USER} mysql

WORKDIR /var/www/html

USER ${USER}

COPY ./src ./

# entrypoint
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
