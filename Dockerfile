# Adds xDebug support to Conetix's docker-wordpress-wp-cli
# Docker Hub: https://registry.hub.docker.com/u/johnrom/docker-wordpress-wp-cli-xdebug/
# Github Repo: https://github.com/johnrom/docker-wordpress-wp-cli-xdebug

FROM wordpress:latest
MAINTAINER web@johnrom.com

# Add sudo in order to run wp-cli as the www-data user
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y sudo less subversion \
    && apt-get -q -y install mysql-server

COPY wp-su.sh /bin/wp
RUN chmod +x /bin/wp

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_output_name=cachegrind.out.%t" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_output_dir=/tmp" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && rm -rf /usr/local/etc/php/conf.d/opcache-recommended.ini

COPY docker-entrypoint.sh /usr/local/bin/

# Set up the command arguments
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/bin/true"]