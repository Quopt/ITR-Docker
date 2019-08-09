# run in either bash or sh
# this script demonstrates a way to start the ITR with docker
# this script takes the following parameters in this specific order
# $1 Name of the website
# $2 Your mail address
# $3 The DB password
# $4 SSH or NOSSH (case sensitive)
# $5 ip address with access to postgresql

# Set the following variables
export WWW=$1
export EMAIL=$2
export PG_PASSWORD=$3
export PG_IP=$5

if [ "$WWW" == "" -o "$EMAIL" == "" ] ; then
        echo Please supply the following parameters in the following order
        echo $1 Name of the website
        echo $2 Your mail address
        echo $3 The DB password
        echo $4 SSH or SSHPRIVATE or NOSSH 
        echo $5 ip address with access to postgresql
        echo Parameter 3 and 4 should only be entered when the server is installed for the first time
        echo Example
        echo './prepareITR.sh training.testdimensions.com info@testdimensionss.com ITR2018! NOSSH'
        exit
fi
set -x

# the following variable can be changed but that is optional
export DBPREFIX=ITR

# Install
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update && sudo apt-get install -y git && sudo apt-get -y upgrade && sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
# change this line depending on your cpu architecture. this assumes x86
sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
# finally install docker
sudo apt-get update  && sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo docker run hello-world

cd /
sudo mkdir data | true
sudo chmod 777 data | true
cd /data
# the following folder will hold all state information for the ITR
# in case of multiple servers this setup needs to be reconsidered
sudo mkdir ITR-data | true
sudo chmod 777 ITR-data | true
sudo mkdir ITR-data/instance | true
sudo mkdir ITR-data/instance/media | true
sudo mkdir -p ITR-data/instance/log/internal | true
sudo mkdir -p ITR-data/instance/log/external | true
sudo mkdir ITR-data/instance/translations | true
sudo mkdir ITR-data/instance/cache | true
sudo mkdir -p ITR-data/database/data | true
sudo mkdir -p ITR-data/database/backup | true
sudo mkdir -p ITR-data/nginx/certificates | true
# get the latest source code from github
sudo git clone https://github.com/Quopt/ITR-webclient.git
sudo git clone https://github.com/Quopt/ITR-public-API.git
sudo git clone https://github.com/Quopt/ITR-API.git
sudo git clone https://github.com/Quopt/ITR-Docker.git

cd ITR-webclient
sudo git fetch --all
sudo git reset --hard origin/master
sudo git pull origin master
cd ..
sudo chmod -R 777 ITR-webclient/
cd ITR-public-API
sudo git fetch --all
sudo git reset --hard origin/master
sudo git pull origin master
cd ..
cd ITR-API
sudo git fetch --all
sudo git reset --hard origin/master
sudo git pull origin master
cd ..
cd ITR-Docker
sudo git fetch --all
sudo git reset --hard origin/master
sudo git pull origin master
cd ..
cd ITR-API
sudo git fetch --all
sudo git reset --hard origin/master
sudo git pull origin master
cd ..

cp ITR-API/requirements.txt ITR-Docker/python3-internal/.
cp ITR-API/requirements.txt ITR-Docker/python3-external/.

# change the configuration files
sudo touch /data/ITR-data/instance/application.cfg
sudo chmod 666 /data/ITR-data/instance/application.cfg
sudo chmod 666 /data/ITR-Docker/nginx/nginx.conf
sudo chmod 666 /data/ITR-Docker/nginx/nginx.conf.template.letsencrypt
envsubst < /data/ITR-API/instance/application.cfg.template > /data/ITR-data/instance/application.cfg
sed 's/$WWW/'$WWW'/g' /data/ITR-Docker/nginx/nginx.conf.template.local > /data/ITR-Docker/nginx/nginx.conf
sed 's/$WWW/'$WWW'/g' /data/ITR-Docker/nginx/nginx.conf.template.siteonly > /data/ITR-Docker/nginx/nginx.conf.template.letsencrypt

if [ "$4" == "SSH" -o "$4" == "SSHPRIVATE" ]; then
 sed 's/$WWW/'$WWW'/g' /data/ITR-Docker/nginx/nginx.conf.template.public > /data/ITR-Docker/nginx/nginx.conf
fi

# prepare for docker start
cd /data/ITR-Docker
sudo rm .env
sudo touch .env
sudo chmod 666 .env
sudo echo PG_PASSWORD=${PG_PASSWORD} > .env
if [ -f "multiwww.txt" ]
then
 echo Multiple www listening addresses found
 sudo echo WWW=$(cat multiwww.txt) >> .env
else
 sudo echo WWW=${WWW} >> .env
fi
sudo echo EMAIL=${EMAIL} >> .env
sudo echo DBPREFIX=${DBPREFIX} >> .env
if [ -z "$PG_IP" ]
then
 export PG_IP=127.0.0.1
fi
sudo echo PG_IP=${PG_IP} >> .env

# build whatever containers are necessary
sudo chmod +x build.sh
sudo ./build.sh

# install certificates 
if [ "$4" == "SSH" ]; then
 sudo docker run -i --rm -v /data/ITR-data/nginx/certificates:/etc/nginx/ssl:z -v /data/ITR-webclient/:/usr/share/nginx/html:z -p 80:80 -e WWW=$WWW itr-nginx-container sh -c "/etc/certbot/letsEncrypt.sh FIRSTSTART"
fi

# The following docker containers will be started
# itr-nginx - hosts the static website and does SSL offloading
# itr-api - the api for the web application
# itr-public-api - the external api for other users
# itr-postgresql - the database for the ITR
sudo apt install -y docker-compose
sudo docker-compose -f ITRStack.yml up -d --force-recreate

sleep 5
if [ -f "multiwww.txt" ]
then
 sudo docker exec -it itr-nginx sh -c /etc/certbot/buildNginx.sh
fi

echo DONE! Wait for the docker containers to start and install 
echo Use for monitoring 
echo  sudo docker logs -f itr-api 



