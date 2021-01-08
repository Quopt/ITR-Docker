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

# save config and prepare 
cp /etc/nginx/nginx.conf /etc/certbot/nginx.conf
if [ -e /etc/certbot/nginx.conf.template.letsencrypt.bkp ]
then
 echo "backup already exists" 
 rm /etc/certbot/nginx.conf.template.letsencrypt
else
 echo "backup created" 
 cp /etc/certbot/nginx.conf.template.letsencrypt /etc/certbot/nginx.conf.template.letsencrypt.bkp
fi 

# get the certificates
for value in $WWW
do
 echo $value
 sed 's/$WWW/'$value'/g' /etc/certbot/nginx.conf.template.letsencrypt.bkp > /etc/certbot/nginx.conf.template.letsencrypt.$value
 cp /etc/certbot/nginx.conf.template.letsencrypt.$value /etc/nginx/nginx.conf
 cat /etc/nginx/nginx.conf
 nginx -s reload
 ./acme.sh --issue --nginx -d $value --key-file /etc/nginx/ssl/$value.key --fullchain-file /etc/nginx/ssl/$value.crt
 cp -r /root/.acme.sh/$value/* /etc/nginx/ssl/. | true
done

# restore config
cp /etc/certbot/nginx.conf /etc/nginx/nginx.conf
nginx -s reload
