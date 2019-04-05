#FROM docker.io/python:3-alpine
FROM postgres:10-alpine

RUN apk update && apk add zip libaio libaio-dev postgresql python3 gcc g++ python3-dev unixodbc unixodbc-dev

WORKDIR /data

RUN pip3 install --upgrade pip

COPY startMe.sh .

ENTRYPOINT ["sh","-c","startMe.sh"]
