#!/bin/bash

set -e 


MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)


mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql


if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    echo "Starting temporary MariaDB..."

    mariadbd \
        --user=mysql \
        --datadir=/var/lib/mysql \
        --socket=/run/mysqld/mysqld.sock &
    
    until mariadb-admin ping --silent; do 
        sleep 1
    done

    echo "Creating database and user..."

    mariadb << EOF 
            CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
            CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
            GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
            ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
            FLUSH PRIVILEGES;
EOF

    echo "Stopping temporary MariaDB..."

    mariadb-admin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown

fi 

exec mariadbd --user=mysql --datadir=/var/lib/mysql


