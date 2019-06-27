FROM php:7.3.6-fpm-alpine3.9 as build-stage

WORKDIR /var/www

RUN apk add bash && \
    apk add composer && \
    apk add php7-gd && \
    apk add php7-curl

RUN rm -rf /var/www/html
# RUN rm -rf /etc/nginx/conf.d/default.conf

# COPY ./nginx.conf /etc/nginx/conf.d
COPY .docker/app/ /var/www
COPY server.sh /var/www
RUN ln -s public html


EXPOSE 9000
ENTRYPOINT ["php-fpm"]