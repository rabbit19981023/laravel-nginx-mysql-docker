FROM nginx:stable

ARG NGINXGROUP
ARG NGINXUSER

ENV NGINXGROUP=${NGINXGROUP}
ENV NGINXUSER=${NGINXUSER}

RUN adduser --disabled-password --gecos '' ${NGINXUSER} \
    && adduser ${NGINXUSER} ${NGINXGROUP}

RUN sed -i "s/user www-data/user ${NGINXUSER}/g" /etc/nginx/nginx.conf
RUN sed -i "s/user www-data/group ${NGINXGROUP}/g" /etc/nginx/nginx.conf

WORKDIR /var/www/html
