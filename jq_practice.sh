#!/usr/bin/env bash

set -e

# get response from the github api and save to the variable
RESPONSE_FROM_GITHUB=$(curl 'https://api.github.com/repos/stedolan/jq/commits?per_page=5')

# print as json all the sha key from the json
echo ${RESPONSE_FROM_GITHUB} | jq .[].sha

# read json from the file and get the key: "images", check images.json
JSON_FROM_FILE=$(cat images.json)

# saving the ids of images in a variable
IMAGES_ID="$(echo ${JSON_FROM_FILE} | jq .images[].id)"

# print all the image ids
echo ${IMAGES_ID}