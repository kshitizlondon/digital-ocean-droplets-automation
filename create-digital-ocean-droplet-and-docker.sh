#!/usr/bin/env bash

set -e

SECRETFILE=.digitalocean
if [[ -z $DIGOCEAN_ID ]] || [[ -z $DIGOCEAN_KEY ]]; then
    if [ -e $SECRETFILE ]; then
        . $SECRETFILE
    fi
fi

if [[ -z $DIGOCEAN_ID ]] || [[ -z $DIGOCEAN_KEY ]]; then
    echo "You need to set the environment variables DIGOCEAN_ID and DIGOCEAN_KEY"
    echo "or provide them in the file $SECRETFILE"
    exit 1
fi

echo "You need to set the environment variables DIGOCEAN_ID and DIGOCEAN_KEY"
CLI_COMMAND=$(docker-machine create --driver digitalocean --digitalocean-access-token $DIGOCEAN_KEY  jenkins1)
echo ${CLI_COMMAND}