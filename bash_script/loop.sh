#!/bin/bash

myvar=1
while [ $myvar -le 15 ]
do
  echo $myvar
  ((myvar++))
done

if [ $myvar -eq 16 ]; then
    echo "The vaiable equals $myvar"
else
    echo "The vaiable not equals $myvar"
fi
