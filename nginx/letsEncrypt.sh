set -x
cd /etc
mkdir certbot
cd certbot
#./certbot-auto --nginx
rm index.html
rm acme.sh
apk add curl openssl
wget  -  https://get.acme.sh
mv index.html acme.sh
chmod +x acme.sh
./acme.sh
cd ~/.acme.sh

./acme.sh --issue --nginx -d $WWW \
--key-file       /etc/nginx/ssl/certificate.key \
--fullchain-file /etc/nginx/ssl/certificate.crt \
--reloadcmd     "service nginx force-reload"

cp /root/.acme.sh/$WWW/* /etc/nginx/ssl/. | true
