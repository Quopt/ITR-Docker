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

mv /etc/nginx/nginx.conf /etc/certbot/nginx.conf
mv /etc/certbot/nginx.conf.template.letsencrypt /etc/nginx/nginx.conf

/usr/sbin/nginx
echo $1

./acme.sh --$1 --nginx -d $WWW \
--key-file       /etc/nginx/ssl/certificate.key \
--fullchain-file /etc/nginx/ssl/certificate.crt \
--reloadcmd     "/usr/sbin/nginx"

cp -r /root/.acme.sh/$WWW/* /etc/nginx/ssl/. | true
mv /etc/certbot/nginx.conf /etc/nginx/nginx.conf 
