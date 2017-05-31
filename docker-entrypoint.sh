#!/bin/bash

#
# TODO: check for environment version
#
if [ ! -f /app/composer.json ]; then
    # Add WP-CLI Dev Version
    curl -Lo /tmp/wp-cli.zip https://github.com/wp-cli/wp-cli/archive/master.zip
    unzip -d /tmp/wp-cli /tmp/wp-cli.zip

    # Kind of cheating?
    cp -R /tmp/wp-cli/wp-cli-master/* /app && ls /
fi

# Need it to stay alive..
while "$@"; do
    read
done
