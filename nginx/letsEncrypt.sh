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

cp /etc/nginx/nginx.conf /etc/certbot/nginx.conf
if [ "$1" == "FIRSTSTART" ]
then
 cp /etc/certbot/nginx.conf.template.letsencrypt /etc/nginx/nginx.conf
fi 

/usr/sbin/nginx
echo $1

for value in $WWW
do
 echo $value
 ./acme.sh --issue --nginx -d $value --key-file /etc/nginx/ssl/$value.key --fullchain-file /etc/nginx/ssl/$value.crt  --reloadcmd  "/usr/sbin/nginx"
 cp -r /root/.acme.sh/$value/* /etc/nginx/ssl/. | true
don
if [ "$1" == "FIRSTSTART" ]
then
 cp /etc/certbot/nginx.conf /etc/nginx/nginx.conf
 nginx -s reload
fi 
