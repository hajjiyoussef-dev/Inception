FROM debian:12

RUN apt update && apt install -y php8.2 php8.2-fpm php8.2-mysql curl 

COPY /conf/www.conf  /etc/php/8.2/fpm/pool.d/www.conf
COPY /tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]