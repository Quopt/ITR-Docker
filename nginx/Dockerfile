FROM docker.io/nginx:1-alpine-perl

USER root

RUN apk update && apk add wget cifs-utils samba samba-common-tools supervisor apache2-utils openrc py-pip gcc musl-dev build-base openldap-dev python2-dev python3-dev

WORKDIR /etc/nginx
COPY nginx.conf nginx.conf

RUN mkdir /etc/nginx/ssl
RUN chmod 666 /etc/nginx/ssl

WORKDIR /etc/certbot
COPY buildNginx.sh buildNginx.sh
COPY nginx.A nginx.A
COPY nginx.B nginx.B
COPY letsEncrypt.sh letsEncrypt.sh
COPY letsEncryptRenew.sh letsEncryptRenew.sh
RUN chmod +x letsEncrypt.sh
RUN chmod +x buildNginx.sh
RUN chmod +x letsEncryptRenew.sh
COPY nginx.conf.template.letsencrypt nginx.conf.template.letsencrypt

RUN echo "0    2       *       *       *       /etc/certbot/letsEncryptRenew.sh" >> /etc/crontabs/root
  
