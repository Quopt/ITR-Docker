# run in either bash or sh
# this script demonstrates a way to start the ITR with docker
# this script takes the following parameters in this specific order
# $1 Name of the website
# $2 Your mail address
# $3 The DB password
# $4 SSH or NOSSH (case sensitive)

# Set the following variables
export WWW=$1
export EMAIL=$2
export PG_PASSWORD=$3

if [ "$WWW" == "" -o "$EMAIL" == "" -o "$PG_PASSWORD" == "" ] ; then
        echo Please supply the following parameters in the following order
        echo $1 Name of the website
        echo $2 Your mail address
        echo $3 The DB password
        echo $4 SSH or NOSSH
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
mkdir ITR-data | true
chmod 777 ITR-data | true
mkdir ITR-data/instance | true
mkdir ITR-data/instance/media | true
mkdir -p ITR-data/instance/log/internal | true
mkdir -p ITR-data/instance/log/external | true
mkdir ITR-data/instance/translations | true
mkdir ITR-data/instance/cache | true
mkdir -p ITR-data/database/data | true
mkdir -p ITR-data/database/backup | true
mkdir -p ITR-data/nginx/certificates | true
# get the latest source code from github
git clone https://github.com/Quopt/ITR-webclient.git
git clone https://github.com/Quopt/ITR-public-API.git
git clone https://github.com/Quopt/ITR-API.git
git clone https://github.com/Quopt/ITR-Docker.git

cd ITR-webclient
git fetch --all
git reset --hard origin/master
cd ..
sudo chmod -R 777 ITR-webclient/
cd ITR-public-API
git fetch --all
git reset --hard origin/master
cd ..
cd ITR-API
git fetch --all
git reset --hard origin/master
cd ..
cd ITR-Docker
git fetch --all
git reset --hard origin/master
cd ..
cd ITR-API
git fetch --all
git reset --hard origin/master
cd ..

# change the configuration files
envsubst < /data/ITR-API/instance/application.cfg.template > /data/ITR-data/instance/application.cfg
sed 's/$WWW/'$WWW'/g' /data/ITR-Docker/nginx/nginx.conf.template.local > /data/ITR-Docker/nginx/nginx.conf
sed 's/$WWW/'$WWW'/g' /data/ITR-Docker/nginx/nginx.conf.template.siteonly > /data/ITR-Docker/nginx/nginx.conf.template.letsencrypt

if [ "$4" == "SSH" ]; then
 sed 's/$WWW/'$WWW'/g' /data/ITR-Docker/nginx/nginx.conf.template.public > /data/ITR-Docker/nginx/nginx.conf
fi

if [ ! "$(ls -A /data/ITR-data/instance/translations)" ]; then
    echo "Initialising translations folder"
    cp /data/ITR-API/instance/translations/*.json /data/ITR-data/instance/translations/.
fi

# prepare for docker start
cd /data/ITR-Docker
echo PG_PASSWORD=${PG_PASSWORD} > .env
echo WWW=${WWW} >> .env
echo EMAIL=${EMAIL} >> .env
echo DBPREFIX=${DBPREFIX} >> .env

# build whatever containers are necessary
chmod +x build.sh
./build.sh

# install certificates 
if [ "$4" == "SSH" ]; then
 sudo docker run -i --rm -v /data/ITR-data/nginx/certificates:/etc/nginx/ssl:z -v /data/ITR-webclient/:/usr/share/nginx/html:z -e WWW=$WWW itr-nginx-container sh -c /etc/certbot/letsEncrypt.sh
fi

# The following docker containers will be started
# itr-nginx - hosts the static website and does SSL offloading
# itr-api - the api for the web application
# itr-public-api - the external api for other users
# itr-certbot - check for the renew of the server certificates every 12 hours
# itr-postgresql - the database for the ITR
sudo apt install -y docker-compose
sudo docker-compose -f ITRStack.yml up -d --force-recreate

echo DONE! Wait for the docker containers to start and install 
echo Use for monitoring 
echo  sudo docker logs -f itr-api 



