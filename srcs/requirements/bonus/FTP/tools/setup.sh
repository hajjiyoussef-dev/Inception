#!/bin/bash

set -e 

FTP_PASSWORD=$( cat  /run/secrets/ftp_password)


if ! id "$FTP_USER" > /dev/null 2>&1; then

    useradd  -d /var/www/html -s /bin/bash "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    
fi

usermod -aG www-data "$FTP_USER"

mkdir -p /var/run/vsftpd/empty

chmod 755 /var/run/vsftpd
chmod 555 /var/run/vsftpd/empty

chgrp -R www-data /var/www/html
chmod -R g+w /var/www/html

echo "Starting vsftpd..."

exec /usr/sbin/vsftpd /etc/vsftpd.conf