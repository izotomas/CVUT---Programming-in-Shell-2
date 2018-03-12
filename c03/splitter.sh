#!/bin/bash
L=$( wc -l < "$1" )
for (( i=0; i <= $L; i+=100 ))
do
	printf -v n "%0${#L}d" $i
	tail -c +$i "$1" | head -n 100 > "$1.$n"
done
