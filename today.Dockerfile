FROM php:7.3.6-fpm-alpine3.9 as build-stage
#WORKDIR /var/www
RUN apk --no-cache add ca-certificates wget && \
	wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
	wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk && \
	apk add glibc-2.29-r0.apk
WORKDIR /usr/local
COPY /.extras/*.zip /usr/local/
RUN apk update
RUN apk add php7-dev php7-pear musl-dev musl libgcc gcc unzip libnsl libarchive-tools libaio bash tar unzip g++ && \
	apk add composer && \

	# Novas dependencias iniciam aqui
	apk add libmemcached libmemcached-libs libmemcached-dev && \
	apk add build-base zlib-dev autoconf cyrus-sasl-dev && \
	pecl config-set php_ini  /usr/local/etc/php/php.ini && \
	pecl install -f memcached \ #Or any Additional packages echo extension=memcached.so >> /usr/local/etc/php/conf.d/docker-php-ext-memcached.ini && \
	rm -rf /tmp/pear  && \
	pecl install oci8 && \
	# Novas dependencias finalizadas


	apk add php7-gd && \
	apk add php7-curl ca-certificates && \
	apk upgrade && \
	unzip basic.zip && \
	unzip sdk.zip && \
	echo 'Descompactando...' && \
	echo 'Descompactando...' && \
	echo 'Descompactando...'
	#ln -s /usr/local/instantclient_10_2 /usr/local/instantclient && \
	#ln -s /usr/local/instantclient/libclntsh.so.* /usr/local/instantclient/libclntsh.so && \
	#ln -s /usr/local/instantclient/lib* /usr/lib && \
	#docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient && \
	#docker-php-ext-install oci8 && \
	#docker-php-ext-enable oci8 && \
	#rm -rf /var/lib/apk/lists/*


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

##### OBS PARA HABILITAR EXTENSÕES PHP (OCI8)

#  To enable extensions, verify that they are enabled in your .ini files:
#    - 
#    - /usr/local/etc/php/conf.d/docker-php-ext-oci8.ini
#    - /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini