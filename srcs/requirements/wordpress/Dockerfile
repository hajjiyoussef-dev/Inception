FROM debian:11


RUN apt update && \
    apt install -y php-fpm php-mysql curl mariadb-client unzip && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY /conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY /tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]