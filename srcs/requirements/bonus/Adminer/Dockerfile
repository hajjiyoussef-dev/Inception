FROM debian:11

RUN apt update && apt install -y php7.4 php7.4-fpm php7.4-mysql curl 

COPY /conf/www.conf  /etc/php/7.4/fpm/pool.d/www.conf
COPY /tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]