FROM php:7.3.6-fpm-alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache \
    freetype \
    libjpeg-turbo \
    libpng \
    libwebp \
    libxpm \
    bzip2 \
    libzip \
    libxml2 \
    libpq \
    gmp \
    enchant \
    libxslt

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libxpm-dev \
    bzip2-dev \
    libzip-dev \
    libxml2-dev \
    postgresql-dev \
    gmp-dev \
    enchant-dev \
    libxslt-dev \
    \
    && docker-php-ext-install \
    \
    calendar \
    bz2 \
    zip \
    soap \
    sockets \
    iconv \
    exif \
    gmp \
    bcmath \
    enchant \
    xmlrpc \
    xsl \
    mysqli \
    pdo_mysql \
    pgsql \
    pdo_pgsql \
    opcache \
    \
    && docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir --with-png-dir --with-webp-dir --with-xpm-dir \ 
    && docker-php-ext-install gd \
    \
    && pecl install redis mongodb msgpack \
    && docker-php-ext-enable redis mongodb msgpack \
    && apk del .build-deps

RUN rm -rf /var/www/html \
    && mkdir -p /website \
    && chown www-data:www-data /website \
    && chmod 777 /website \
    && { \
		echo '[global]'; \
		echo 'daemonize = no'; \
	} | tee /usr/local/etc/php-fpm.d/zz-docker.conf

WORKDIR /website