#!/bin/bash

set -e 

mkdir -p /etc/nginx/ssl


if [ ! -f /etc/nginx/ssl/nginx.crt ]; then 

    echo "Generating SSL certificate..."

    openssl req \
        -x509 \
        -nodes \
        -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=MA/ST=Khouribga/L=Khouribga/O=42/CN=yhajji.42.fr"
    
fi 
echo "Starting NGINX..."

exec nginx -g "daemon off;"
