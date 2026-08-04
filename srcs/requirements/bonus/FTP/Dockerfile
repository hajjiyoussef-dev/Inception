FROM debian:12

RUN apt update && apt install -y vsftpd

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/setup.sh  /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]