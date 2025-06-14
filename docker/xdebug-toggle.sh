#!/bin/bash
# Script para habilitar/desabilitar o Xdebug no container
# Uso: ./xdebug-toggle.sh [on|off]

CONTAINER_NAME="realestate_app"

if [ "$1" = "on" ]; then
    echo "Habilitando Xdebug..."
    docker exec $CONTAINER_NAME sed -i 's/;zend_extension=xdebug/zend_extension=xdebug/' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
    docker exec $CONTAINER_NAME pkill -USR2 php-fpm
    echo "Xdebug habilitado! Reinicie o PHP-FPM se necessário."
elif [ "$1" = "off" ]; then
    echo "Desabilitando Xdebug..."
    docker exec $CONTAINER_NAME sed -i 's/zend_extension=xdebug/;zend_extension=xdebug/' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
    docker exec $CONTAINER_NAME pkill -USR2 php-fpm
    echo "Xdebug desabilitado!"
else
    echo "Uso: $0 [on|off]"
    echo "  on  - Habilita o Xdebug"
    echo "  off - Desabilita o Xdebug"
fi
