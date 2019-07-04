FROM php:7.3.6-fpm-alpine3.9 as build-stage
#WORKDIR /var/www
WORKDIR /usr/local
COPY /.extras/*.zip /usr/local/

RUN apk update
RUN apk add php7-dev gcc musl-dev musl unzip libnsl libarchive-tools libaio bash tar unzip && \
	apk add composer && \
	apk add php7-gd && \
	apk add php7-curl ca-certificates && \
	apk upgrade && \
	unzip basic.zip && \
	unzip sdk.zip && \
	ln -s /usr/local/instantclient_10_2 /usr/local/instantclient && \
	ln -s /usr/local/instantclient/libclntsh.so.* /usr/local/instantclient/libclntsh.so && \
	ln -s /usr/local/instantclient/lib* /usr/lib && \
	docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient && \
	docker-php-ext-install oci8 && \
	docker-php-ext-enable oci8 && \
	rm -rf /var/lib/apk/lists/*

WORKDIR /var/www

RUN rm -rf /var/www/html
# RUN rm -rf /etc/nginx/conf.d/default.conf
# COPY ./nginx.conf /etc/nginx/conf.d

COPY .docker/app/ /var/www
COPY server.sh /var/www
RUN ln -s public html

WORKDIR /usr/local/etc/php/conf.d
RUN ls -a

EXPOSE 9000
ENTRYPOINT ["php-fpm"]