FROM ubuntu@sha256:9d6a8699fb5c9c39cf08a0871bd6219f0400981c570894cd8cbea30d3424a31f as base_system

ARG TZ
ARG MYSQL_ROOT_PASSWORD
ARG USER

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
    php8.0-fpm

# php-fpm config
# we will use volumes instead for development
# COPY ./php-fpm.pool.conf /
# RUN cat /php-fpm.pool.conf > /etc/php/8.0/fpm/pool.d/www.conf \
#     && rm -f /php-fpm.pool.conf

# install php-extensions (php core modules)
RUN for package in \
    unzip \
    openssl \
    php8.0-common \
    php8.0-curl \
    php8.0-json \
    php8.0-xml \
    php8.0-mbstring \
    php8.0-bcmath \
    php8.0-zip \
    php8.0-mysql \
    php8.0-redis \
    php8.0-sockets; \
    do \
    apt-get install -y $package; \
    done

# install composer (PHP Packages Manager)
# method 1
RUN apt-get install -y curl \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

# method 2 (Official)
# RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
#     && php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
#     && php composer-setup.php \
#     && php -r "unlink('composer-setup.php');"

# install Nginx Server
RUN apt-get install --no-install-recommends --no-install-suggests -y ca-certificates nginx
# nginx config
# we will use volumes instead for development
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

# install Node.js for laravel core
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest

# install development tools
RUN apt-get install -y \
    vim \
    git

### We will use volumes instead for development
# COPY --chown=${USER}:${USER} ./src /var/www/html

# entrypoint
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR /var/www/html

USER ${USER}
