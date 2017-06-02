# Adds xDebug support to Conetix's docker-wordpress-wp-cli
# Docker Hub: https://registry.hub.docker.com/u/johnrom/docker-wordpress-wp-cli-xdebug/
# Github Repo: https://github.com/johnrom/docker-wordpress-wp-cli-xdebug

FROM wordpress:cli-php7.0
MAINTAINER web@johnrom.com

USER root

# From https://hub.docker.com/r/composer/composer/~/dockerfile/
# Packages
RUN apk --update add \
    autoconf \
    build-base \
    curl \
    git \
    subversion \
    freetype-dev \
    libjpeg-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libbz2 \
    bzip2-dev \
    libstdc++ \
    libxslt-dev \
    openldap-dev \
    make \
    unzip \
    wget && \
    docker-php-ext-install bcmath mcrypt zip bz2 mbstring pcntl xsl && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    docker-php-ext-configure ldap --with-libdir=lib/ && \
    docker-php-ext-install ldap && \
    apk del build-base && \
    rm -rf /var/cache/apk/*

# PEAR tmp fix
RUN echo "@community http://dl-4.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories \
    && apk add --update \
        php7-pear@community \
    && rm -rf /var/cache/apk/*

# Set up the volumes and working directory
VOLUME ["/app"]
WORKDIR /app

RUN apk --update add --no-cache --virtual .xdebug-build-deps \
        autoconf \
        build-base \
        make \
    && pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_output_name=cachegrind.out.%t" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_output_dir=/tmp" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && rm -rf /usr/local/etc/php/conf.d/opcache-recommended.ini \
    && apk del .xdebug-build-deps

RUN apk --update add \
        bash \
    && rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /usr/local/bin/

USER www-data

# Set up the command arguments
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/bin/true"]
