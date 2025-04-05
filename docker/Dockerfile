FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    nginx supervisor curl unzip git libpq-dev libzip-dev libonig-dev libxml2-dev libssl-dev \
    libjpeg-dev libpng-dev libfreetype6-dev libwebp-dev libxpm-dev libicu-dev \
    && docker-php-ext-install pdo pdo_pgsql zip intl opcache gd

RUN pecl install redis \
    && docker-php-ext-enable redis


COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY docker/php/php.ini /usr/local/etc/php/conf.d/app.ini
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /var/www

EXPOSE 80

CMD ["/usr/bin/supervisord"]
