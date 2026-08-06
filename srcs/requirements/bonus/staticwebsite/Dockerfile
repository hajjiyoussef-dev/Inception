FROM debian:12

RUN apt-get update && \
    apt-get install -y nginx

RUN mkdir -p /var/www/static

COPY website/index.html   /var/www/static

ENTRYPOINT ["nginx", "-g", "daemon off;"]
