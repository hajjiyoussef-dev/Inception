FROM debian:bullseye

RUN apt-get update && \ 
    apt-get install -y mariadb-server && \
    apt-get clean

COPY conf/my.cnf etc/mysql/mariadb.conf.d/50-server.cnf 
COPY tools/setup.sh /setup.sh

ENTRYPOINT ["/setup.sh"]
