FROM debian:11

RUN apt update && \
    apt install -y nginx openssl

COPY conf/default.conf /etc/nginx/conf.d/default.conf

COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]