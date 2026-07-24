#!/bin/bash

set -e 

FTP_PASSWORD=$( cat  /run/secrets/ftp_password)

useradd -m -d /var/www/html -s /bin/bash "$FTP_USER"

echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

echo "Starting vsftpd..."

exec /usr/sbin/vsftpd /etc/vsftpd.conf