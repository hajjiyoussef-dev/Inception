#!/bin/bash

set -e 



if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    
    mariadbd  --user=mysql \
        --bootstrap << EOF 
            CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
            CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        EOF
fi 


