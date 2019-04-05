FROM docker.io/nginx:1-alpine-perl

USER root

RUN apk update && apk add wget cifs-utils samba samba-common-tools supervisor apache2-utils openrc py-pip gcc musl-dev build-base openldap-dev python2-dev python3-dev

WORKDIR /etc/nginx
COPY nginx.conf nginx.conf

WORKDIR /etc/nginc/conf.d
COPY itr_site.conf . 

RUN mkdir /etc/nginx/ssl
RUN chmod 666 /etc/nginx/ssl
