apk add curl openssl
wget  -  https://get.acme.sh
mv index.html acme.sh
chmod +x acme.sh
./acme.sh --install --nocron

export DOMAIN_PATH=/etc/nginx/ssl
~/.acme.sh/acme.sh --renew --nginx -d $WWW \
 --reloadcmd  "/usr/sbin/nginx -s reload" --home /etc/nginx 
cd /etc/nginx/ssl
file1=`md5sum certificate.crt | cut -d' ' -f1`
file2=`md5sum $WWW.cer | cut -d' ' -f1`
if [ ! "$file1" == "$file2" ]
then
 echo Installing new certificate and restarting nginx
 cp $WWW.cer certificate.crt
 /usr/sbin/nginx -s reload
else
 echo Certificate is not renewed ...
fi

