#!/bin/bash

#
# TODO: check for environment version
#
if [ ! -f /app/composer.json ]; then
    echo "Installing Composer"

    # Add WP-CLI Dev Version
    curl -Lo /tmp/wp-cli.zip https://github.com/wp-cli/wp-cli/archive/master.zip
    unzip -d /tmp/wp-cli /tmp/wp-cli.zip

    cp -R /tmp/wp-cli/wp-cli-master/* /app
fi

# Need it to stay alive..
while "$@"; do
    :
done
