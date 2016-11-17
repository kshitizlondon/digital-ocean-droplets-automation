#!/usr/bin/env bash

#declaring array by keys
declare -A systeminfo

# 1st way to sote cli command output to a variable
systeminfo["Size"]="$(df -h | grep disk1 | awk '{print $2}')"

# 2nd way to sote cli command output to a variable
systeminfo["Used"]=`df -h | grep disk1 | awk '{print $3}'`
systeminfo["Available"]=`df -h | grep disk1 | awk '{print $4}'`
systeminfo["Capacity"]=`df -h | grep disk1 | awk '{print $5}'`

echo "-- System Info:"
echo -e "\t Bash Version:" $BASH_VERSION
echo -e "\t\t HostName:" $HOSTNAME

for key in ${!systeminfo[@]}; do
    echo -e "\t\t" ${key} ${systeminfo[${key}]}
done
