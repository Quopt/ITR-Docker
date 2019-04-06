apk add curl openssl
wget  -  https://get.acme.sh
mv index.html acme.sh
chmod +x acme.sh
./acme.sh --install --nocron

~/.acme.sh/acme.sh --renew --nginx -d $WWW \
 --reloadcmd  "/usr/sbin/nginx -s reload"
