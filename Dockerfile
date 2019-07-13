FROM php:7.3.6-fpm-alpine3.9 as build-stage
#WORKDIR /var/www
COPY ./instantclient-basic-linux.x64-18.5.zip /usr/local
COPY ./instantclient-sdk-linux.x64-18.5.zip /usr/local


WORKDIR /usr/local
COPY /.extras/*.zip /usr/local/

RUN apk update
RUN apk --no-cache add ca-certificates wget && \
	wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
	wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk && \
	apk add glibc-2.29-r0.apk

RUN apk add php7-dev php7-pear gcc musl-dev musl unzip libnsl libarchive-tools libaio bash tar unzip g++ && \
	apk add composer && \
	apk add php7-gd && \
	apk add php7-curl ca-certificates && \
	apk upgrade && \
	unzip instantclient-basic-linux.x64-18.5.zip && \
	unzip instantclient-sdk-linux.x64-18.5.zip && \
	ln -s /usr/local/instantclient_18_5 /usr/local/instantclient && \
	ln -s /usr/local/instantclient/libclntsh.so.* /usr/local/instantclient/libclntsh.so && \
	ln -s /usr/local/instantclient/lib* /usr/lib && \
	docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient && \
	docker-php-ext-install oci8 && \
	docker-php-ext-enable oci8 && \
	rm -rf /var/lib/apk/lists/*

RUN pecl config-set php_ini  /usr/local/etc/php/php.ini && \
	pecl install -f memcached \ #Or any Additional packages echo extension=memcached.so >> /usr/local/etc/php/conf.d/docker-php-ext-memcached.ini && \
	rm -rf /tmp/pear  && \
	pecl install oci8

WORKDIR /var/www

RUN rm -rf /var/www/html
# RUN rm -rf /etc/nginx/conf.d/default.conf
# COPY ./nginx.conf /etc/nginx/conf.d

COPY .docker/app/ /var/www
COPY server.sh /var/www
RUN ln -s public html

#WORKDIR /usr/local/etc/php/conf.d
#RUN ls -a

EXPOSE 9000
ENTRYPOINT ["php-fpm"]