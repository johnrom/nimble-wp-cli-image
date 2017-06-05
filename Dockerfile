# Adds xDebug support to Conetix's docker-wordpress-wp-cli
# Docker Hub: https://registry.hub.docker.com/u/johnrom/docker-wordpress-wp-cli-xdebug/
# Github Repo: https://github.com/johnrom/docker-wordpress-wp-cli-xdebug

FROM wordpress:cli-php7.0
MAINTAINER web@johnrom.com

USER root

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
        unzip \
        bash \
    && rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /usr/local/bin/

USER www-data

# Set up the command arguments
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/bin/true"]
