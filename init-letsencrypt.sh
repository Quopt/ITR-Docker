#!/bin/bash

domains=(training.testdimensions.com)
rsa_key_size=4096
data_path="/data/ITR-Docker/data/certbot"
email="" # Adding a valid address is strongly recommended
staging=0 # Set to 1 if you're testing your setup to avoid hitting request limits

if [ -d "" ]; then
  echo "Existing data found for . Existing certificates will be replaced." 
fi


if [ ! -e "/conf/options-ssl-nginx.conf" ] || [ ! -e "/conf/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/options-ssl-nginx.conf > "/conf/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/ssl-dhparams.pem > "/conf/ssl-dhparams.pem"
  echo
fi

echo "### Creating dummy certificate for  ..."
path="/etc/letsencrypt/live/"
mkdir -p "/conf/live/"
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '/privkey.pem' \
    -out '/fullchain.pem' \
    -subj '/CN=localhost'" certbot
echo


echo "### Starting nginx ..."
docker-compose up --force-recreate -d nginx
echo

echo "### Deleting dummy certificate for  ..."
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/ && \
  rm -Rf /etc/letsencrypt/archive/ && \
  rm -Rf /etc/letsencrypt/renewal/.conf" certbot
echo


echo "### Requesting Let's Encrypt certificate for  ..."
#Join  to -d args
domain_args=""
for domain in "${domains[@]}"; do
  domain_args=" -d "
done

# Select appropriate email arg
case "certificates@testdimensions.com" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email certificates@testdimensions.com" ;;
esac

# Enable staging mode if needed
if [  != "0" ]; then staging_arg="--staging"; fi

docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
     \
     \
     \
    --rsa-key-size  \
    --agree-tos \
    --force-renewal" certbot
echo

echo "### Reloading nginx ..."
docker-compose exec itr-nginx nginx -s reload
