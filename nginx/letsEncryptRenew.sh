apk add curl openssl
wget  -  https://get.acme.sh
mv index.html acme.sh
chmod +x acme.sh
./acme.sh --install --nocron

export DOMAIN_PATH=/etc/nginx/ssl
for value in $WWW
do
 ~/.acme.sh/acme.sh --renew --nginx -d $value \
  --reloadcmd  "/usr/sbin/nginx -s reload" --home /etc/nginx 
done
cd /etc/nginx/ssl
echo Restarting nginx
/usr/sbin/nginx -s reload
