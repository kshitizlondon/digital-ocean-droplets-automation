#!/usr/bin/env bash

#declaring array by keys
declare -A systeminfo

df -h | while read line
do
echo $line
done