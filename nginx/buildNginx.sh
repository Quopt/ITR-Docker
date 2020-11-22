
cd /etc/certbot/
export WWWOLD=$WWW
for value in $WWWOLD
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

export temp=s/'$WWW'/$WWW/g
export temp=$(echo `expr "'$temp'"`)
export temp=$(echo sed $temp nginx.conf.template.letsencrypt.org)
echo $temp > temp.sh
chmod +x temp.sh
./temp.sh > nginx.conf.template.letsencrypt
