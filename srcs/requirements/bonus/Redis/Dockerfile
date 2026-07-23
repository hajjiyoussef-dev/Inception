FROM debian:11

RUN apt update && \
    apt install -y redis-server redis-tools

RUN sed -i 's/bind 127.0.0.1/# bind 127.0.0.1/' /etc/redis/redis.conf

ENTRYPOINT ["redis-server", "--protected-mode", "no"]