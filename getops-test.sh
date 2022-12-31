#!/bin/bash

echo original parameters=[$@]

ARGS=$(getopt -o ab:c:: --long along,blong:,clong:: -n "$0" -- "$@")
if [ $? != 0 ]; then
    echo "Terminating ..."
    exit 1
fi

echo $ARGS
