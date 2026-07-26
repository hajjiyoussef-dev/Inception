FROM debian:12

RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates

RUN curl -L https://github.com/portainer/portainer/releases/download/2.39.4/portainer-2.39.4-linux-amd64.tar.gz \
    -o portainer.tar.gz

RUN mkdir -p /app && \
    tar -xzf portainer.tar.gz -C /app && \
    rm portainer.tar.gz

WORKDIR /app/portainer

EXPOSE 9000

CMD ["./portainer"]
