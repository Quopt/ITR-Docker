
   server {
    client_max_body_size 20M;
    listen 443 ssl http2;
    listen [::]:443 http2;

    ssl_certificate      /etc/nginx/ssl/$WWWInstance.crt;
    ssl_certificate_key  /etc/nginx/ssl/$WWWInstance.key;

    root /usr/share/nginx/html/;
    server_name $WWWInstance;

    location ~ ^(\/api).* {
      proxy_pass http://backend-itr-api;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-Host  $host;
      proxy_set_header X-Forwarded-Port  $server_port;  
      proxy_http_version 1.1;
      proxy_set_header Connection "";      
    }

    location ~ ^(\/externalapi).* {
      proxy_pass http://backend-itr-api-public;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-Host  $host;
      proxy_set_header X-Forwarded-Port  $server_port;  
      proxy_http_version 1.1;
      proxy_set_header Connection "";      
    }

    location ~ ^(?!\/api|\/externalapi).* {
      try_files $uri $uri_lowercase /default.htm =404;
    }
  }

