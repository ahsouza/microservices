FROM php:7.3.6-fpm-alpine3.9 as build-stage

WORKDIR /var/www

RUN apk add bash zenity && \
    apk add composer

RUN rm -rf /var/www/html

COPY .docker/app/ /var/www
COPY server.sh /var/www
RUN ln -s public html


EXPOSE 9000
ENTRYPOINT ["php-fpm"]