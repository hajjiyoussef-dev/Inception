#!/bin/bash

set -e 

mkdir -p /var/www/adminer

curl -L \
    https://github.com/vrana/adminer/releases/download/v5.3.0/adminer-5.3.0.php \
    -o /var/www/adminer/index.php

chown -R www-data:www-data /var/www/adminer

mkdir -p /run/php

exec php-fpm7.4 -F