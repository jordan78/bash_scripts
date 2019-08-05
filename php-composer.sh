#!/bin/bash

COMPOSER=/usr/local/bin/composer

echo 
echo "This script will attempt to download and install php composer"
echo "-------------------------------------------------------------"

echo "Prerequisite.. making sure PHP is installed.................."
if yum list php | grep "php.x86_64" > /dev/null; then 
     echo "PHP already installed."
     printf '\n'
else
     yum -y install php >> /dev/null 2>&1
     echo "installing php.........................................."
     printf '\n'
fi

set http_proxy=http://
set https_proxy=http://
echo "Exporting HTTP Proxy........................................."
printf '\n'

## check if composer already installed 

if test -f "$COMPOSER"; then
   echo "composer already installed. Nothing to do................"
else
   curl -sS https://getcomposer.org/installer | php >> /dev/null 2>&1 
   echo "downloading the latest composer package...................."
   mv composer.phar /usr/local/bin/composer
   chmod +x /usr/local/bin/composer
   echo "composer was installed sucessfully............................"
fi

printf '\n'
echo "$ composer -V"
