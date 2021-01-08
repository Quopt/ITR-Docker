cd /etc/certbot/
# acquire certificates
export WWWOLD=$WWW
if [ "$1" == "FIRSTSTART" ]
then
 ./letsEncrypt.sh
 cd /etc/certbot/
fi 

# build nginx production configuration
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
