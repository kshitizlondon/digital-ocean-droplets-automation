#!/usr/bin/env bash

#declaring array by keys
area[11]=23
area[13]=37
area[51]=UFOs

# displays array's value for this index. If no index is supplied, array element 0 is assumed
echo "value of area[11] is" ${area[11]}
echo "value of area[51] is" ${area[51]}

# to find out the length of any element in the array
echo "Element length is" ${#area[11]}

# to find out how many values there are in the array
echo "Array length is" ${#area[@]}

#declaring entire array
area1=(1 2 3)
echo "value of area1[0] is" ${area1[0]}