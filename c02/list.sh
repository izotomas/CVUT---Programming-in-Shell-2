#!/bin/bash
for i in *
do
	if [ -f "$i" ]
	then
		ls -ld $1 | tr -s ' ' | cut -d' ' -f5,9
	else
		echo "$1 is not a file"
	fi
done
