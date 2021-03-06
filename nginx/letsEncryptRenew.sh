cd /etc/certbot
date
apk add curl openssl
wget  -  https://get.acme.sh
mv index.html acme.sh
chmod +x acme.sh
./acme.sh --install --nocron

export DOMAIN_PATH=/etc/nginx/ssl
mkdir /etc/nginx/ssl/keybkp || true
cp /etc/nginx/ssl/*.key /etc/nginx/ssl/keybkp

echo $WWW
for value in $WWW
do
 echo $value
 ~/.acme.sh/acme.sh --renew --nginx -d $value --reloadcmd  "/usr/sbin/nginx -s reload" --home /etc/nginx $@ || true
done

cd /etc/nginx/ssl
cp keybkp/*.key .

echo Restarting nginx
/usr/sbin/nginx -s reload
