
cd /etc/certbot/
export WWWOLD=$WWW
for value in $WWW
do
 export WWW=$value
 sed 's/$WWWInstance/server_name '$value';/g' nginx.A2 > nginx.conf
 cp nginx.conf /etc/nginx/nginx.conf
 cat /etc/nginx/nginx.conf
 ./letsEncrypt.sh
 cd /etc/certbot/
done

export WWW=$WWWOLD
cat nginx.A > nginx.conf
for value in $WWW
do
 export WWWInstance=$value
 sed 's/$WWWInstance/'$WWWInstance'/g' nginx.B >> nginx.conf
done
echo } >> nginx.conf
cp nginx.conf /etc/nginx/nginx.conf
nginx -s reload
