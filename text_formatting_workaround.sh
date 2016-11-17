#!/usr/bin/env bash

greentext="\033[32m"

bold="\033[1m"

normal="\033[0m"

sometext="This is some text."

echo -e $bold"Bold Text."
echo -e $normal"Text Again Back To Normal."
echo -e $bold$greentext"Bold Text Green In Color."
echo -e $normal"Text Again Back To Normal."

#todo
echo -e "\e[1mbold\e[0m"
echo -e "\e[3mitalic\e[0m"
echo -e "\e[4munderline\e[0m"
echo -e "\e[9mstrikethrough\e[0m"
echo -e "\e[31mHello World\e[0m"
echo -e "\x1B[31mHello World\e[0m"

printf "\tSystem type:\t%s\n" $sometext

printf "\tSystem type:\t%s\n" $MACHTYPE
printf "\tBash Version:\t%s\n" $BASH_VERSION
