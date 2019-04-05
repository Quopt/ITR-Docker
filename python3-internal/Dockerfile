FROM postgres:10-alpine

RUN apk update && apk add zip libaio libaio-dev postgresql python3 gcc g++ python3-dev unixodbc unixodbc-dev

WORKDIR /data

RUN pip3 install --upgrade pip

WORKDIR /etc/ITR

COPY startMe.sh .
RUN chmod 777 startMe.sh && chmod +X startMe.sh

ENTRYPOINT ["sh","-c","/etc/ITR/startMe.sh"]
