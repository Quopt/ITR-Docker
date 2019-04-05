cd postgres
sudo docker build -t itr-postgres-container .
cd ..
cd nginx
sudo docker build -t itr-nginx-container .
cd ..
cd python3-external
sudo docker build -t itr-external-api-container .
cd ..
cd python3-internal
sudo docker build -t itr-internal-api-container .
cd ..
