FROM ubuntu@sha256:9d6a8699fb5c9c39cf08a0871bd6219f0400981c570894cd8cbea30d3424a31f as base_system

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
RUN apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update
RUN apt-get install -y \
    php8.0-fpm \
    php-mysql

### We will use volumes instead for development
# COPY ./php-fpm.pool.conf /
# RUN cat /php-fpm.pool.conf >> /etc/php/8.0/fpm/pool.d/www.conf \
#     && rm -f /php-fpm.pool.conf

# install Nginx Server
RUN apt-get install --no-install-recommends --no-install-suggests -y ca-certificates nginx
### We will use volumes instead for development
# COPY ./nginx.conf /
# RUN cat /nginx.conf > /etc/nginx/sites-available/default \
#     && ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/ \
#     && rm -f /nginx.conf

# install MariaDB Server
RUN apt-get install -y mariadb-server
RUN apt-get install -y expect
COPY ./mysql_secure_installation.sh /
RUN ./mysql_secure_installation.sh -root-password ${MYSQL_ROOT_PASSWORD} \
    && rm -f ./mysql_secure_installation.sh
RUN adduser ${USER} mysql

# install Redis Server
RUN apt-get install -y redis-server
RUN adduser ${USER} redis

WORKDIR /var/www/html

### We will use volumes instead for development
# COPY --chown=${USER}:${USER} ./src ./

# entrypoint
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

USER ${USER}
