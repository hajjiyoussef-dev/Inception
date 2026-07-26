#!/bin/bash

set -e 

mkdir -p /data

echo "Starting Portainer..."

exec /app/portainer --data /data