FROM docker.io/ubuntu:bionic

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y python3-pip firefox build-essential libssl-dev libffi-dev python-dev vim git wget xvfb && \
    pip3 install -U selenium && \
    pip3 install -U pyvirtualdisplay && \
    pip3 install bs4 && \
    cd /opt && \
    mkdir geckodriver && \
    cd geckodriver && \
    wget https://github.com/mozilla/geckodriver/releases/download/v0.21.0/geckodriver-v0.21.0-linux64.tar.gz && \
    tar -xvzf geckodriver* && \
    chmod +x geckodriver && \
    export PATH=$PATH:/opt/geckodriver && \
    pip3 install --upgrade pip && \
    apt-get install -y unixodbc unixodbc-dev openssl-dev libffi-dev 
	
ENV PATH="/opt/geckodriver:${PATH}"

WORKDIR /etc/ITR 

COPY startMe.sh .
COPY requirements.txt .
RUN chmod 777 startMe.sh && chmod +X startMe.sh && \
    pip install -r requirements.txt

ENTRYPOINT ["bash","-c","/etc/ITR/startMe.sh"]
