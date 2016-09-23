#!/usr/bin/env bash

name=$1
log_file="logs/log_argument.txt"

if [[ -n "$name" ]]; then
    echo "$1=$( date +%s )" >> ${log_file}
else
    echo "argument error"
fi

cat logs/log_argument.txt