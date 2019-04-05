FROM docker.io/python:3-alpine

RUN apk update && apk add zip libaio libaio-dev postgresql

WORKDIR /data

RUN pip install --upgrade pip
