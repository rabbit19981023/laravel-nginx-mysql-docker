FROM nginx:stable-alpine

ARG NGINXGROUP
ARG NGINXUSER

ENV NGINXGROUP=${NGINXGROUP}
ENV NGINXUSER=${NGINXUSER}

RUN adduser -g ${NGINXGROUP} -s /bin/sh -D ${NGINXUSER}; exit 0

RUN sed -i "s/user www-data/user ${NGINXUSER}/g" /etc/nginx/nginx.conf
RUN sed -i "s/user www-data/group ${NGINXGROUP}/g" /etc/nginx/nginx.conf

COPY ./default.conf /etc/nginx/conf.d/

RUN mkdir -p /var/www/html

# USER ${NGINXUSER}:${NGINXGROUP}
