cat nginx.A > nginx.conf
for value in $WWW
do
 export WWWInstance=$value
 cat nginx.A > nginx.conf
 sed 's/$WWWInstance/'$WWWInstance'/g' nginx.B >> nginx.conf
 echo } >> nginx.conf
 cp nginx.conf /etc/nginx/nginx.conf
 ./letsEncrypt.sh
done



cat nginx.A > nginx.conf
for value in $WWW
do
 export WWWInstance=$value
 sed 's/$WWWInstance/'$WWWInstance'/g' nginx.B >> nginx.conf
done
echo } >> nginx.conf
cp nginx.conf /etc/nginx/nginx.conf
nginx -s reload
