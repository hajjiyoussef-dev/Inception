FROM debian:bullseye

RUN apt-get update && \ 
    apt-get install -y mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
