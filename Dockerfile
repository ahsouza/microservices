FROM php:7.3.6-fpm-alpine3.9 as build-stage
#WORKDIR /var/www
WORKDIR /usr/local
COPY /.extras/*.zip /usr/local/

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN apk update && apk upgrade
RUN apk --no-cache add ca-certificates wget && \
 wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
 wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk && \
 apk add glibc-2.29-r0.apk

RUN apk add --update --no-cache \
	nano \
	coreutils \
	php7-cli \
	php7-json \
	php7-openssl \
	php7-iconv \
	php7-ctype \
	php7-soap \
	php7-dom \
	php7-bcmath \
	php7-pgsql \
	php7-curl \
	php7-gd \
	php7-pear \
	php7-redis \
	php7-dev \
    php7-apcu \
    php7-imagick \
    php7-intl \
    php7-mcrypt \
    php7-fileinfo \
    php7-mbstring \
    php7-opcache \
    php7-pdo \
    php7-pdo_mysql \
    php7-mysqli \
    php7-xml \
    php7-zlib \
    php7-phar \
    php7-tokenizer \
    php7-session \
    php7-simplexml \
    php7-xdebug \
    php7-zip \
    php7-xmlwriter \
    curl

RUN apk add nodejs \
	gconf-service \
	libasound2 \
	libatk1.0-0 \
	libc6 \
	libcairo2 \
	libcups2 \
	libdbus-1-3 \
	libexpat1 \
	libfontconfig1 \
	libgcc1 \
	libgconf-2-4 \
	libgdk-pixbuf2.0-0 \
	libglib2.0-0 \
	libgtk-3-0 \
	libnspr4 \
	libpango-1.0-0 \
	libpangocairo-1.0-0 \
	libstdc++6 \
	libx11-6 \
	libx11-xcb1 \
	libxcb1 \
	libxcomposite1 \
	libxcursor1 \
	libxdamage1 \
	libxext6 \
	libxfixes3 \
	libxi6 \
	libxrandr2 \
	libxrender1 \
	libxss1 \
	libxtst6 \
	fonts-liberation \
	libappindicator1 \
	libnss3 \
	lsb-release \
	xdg-utils 


RUN apk add make gcc musl-dev musl unzip libnsl libarchive-tools libaio icu-dev zlib-dev bash tar unzip g++ && \
 apk add composer && \
 apk add ca-certificates && \
 apk upgrade && \
 unzip basic.zip -d /usr/local/ && \
 unzip sdk.zip -d /usr/local/ && \

 ln -s /usr/local/instantclient_18_5 /usr/local/instantclient && \
 export LD_LIBRARY_PATH=/usr/local/instantclient && \
# ln -s /usr/local/instantclient/libclntsh.so.* /usr/local/instantclient/libclntsh.so && \
# ln -s /usr/local/instantclient/lib* /usr/lib && \

 #docker-php-ext-configure intl && \
 docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient && \
 docker-php-ext-install oci8 && \
 #docker-php-ext-install intl && \
 echo 'instantclient,/usr/local/instantclient' | pecl install oci8 && \
 echo "extension=oci8.so" >> /usr/local/etc/php/php.ini && \
 rm -rf /usr/local/*.zip
 #echo "extension=sodium.so" >> /usr/local/etc/php/php.ini && \
 #echo "extension=intl.so" >> /usr/local/etc/php/php.ini && \
 # docker-php-ext-install oci8 && \
 # docker-php-ext-enable oci8 && \
 # rm -rf /var/lib/apk/lists/*
# RUN pecl config-set php_ini  /usr/local/etc/php/php.ini && \
#  pecl install -f memcached \ #Or any Additional packages echo extension=memcached.so >> /usr/local/etc/php/conf.d/docker-php-ext-memcached.ini && \
#  rm -rf /tmp/pear  && \
#  pecl install oci8

WORKDIR /var/www

RUN rm -rf /var/www/html
# RUN rm -rf /etc/nginx/conf.d/default.conf
# COPY ./nginx.conf /etc/nginx/conf.d

COPY .docker/app/ /var/www
#COPY server.sh /var/www
RUN ln -s public html

#WORKDIR /usr/local/etc/php/conf.d
#RUN ls -a

EXPOSE 9000
ENTRYPOINT ["php-fpm"]