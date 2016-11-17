#!/usr/bin/env bash

greentext="\033[32m"

bold="\033[1m"

normal="\033[0m"

sometext="This is some text."

echo -e $bold"Bold Text."
echo -e $normal"Text Again Back To Normal."
echo -e $bold$greentext"Bold Text Green In Color."
echo -e $normal"Text Again Back To Normal."

printf "\tSystem type:\t%s\n" $sometext

printf "\tSystem type:\t%s\n" $MACHTYPE
printf "\tBash Version:\t%s\n" $BASH_VERSION
