FROM composer:latest

ARG PHPGROUP
ARG PHPUSER

ENV PHPGROUP=${PHPGROUP}
ENV PHPUSER=${PHPUSER}

RUN adduser --disabled-password --gecos '' ${PHPUSER} \
    && adduser ${PHPUSER} ${PHPGROUP}

WORKDIR /var/www/html
