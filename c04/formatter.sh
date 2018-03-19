#!/bin/bash
LINE=$(grep 'status' log | tail -n 1)
DT=$(echo $LINE | grep -o -E "[^\[].*[^\]]")
DATE=$(echo $DT | cut -d- -f1)
TIME=$(echo $DT | cut -d- -f2)
SEMESTER=$(echo $LINE | grep -o '[')
printf "DATE\t\t%s\n" "$DATE"
printf "TIME\t\t%s\n" "$TIME"
LINE=$(echo $LINE | cut -d' ' -f3 | grep -o '[^status>].*')
for i in {1..5}
do
	PART=$(echo $LINE | cut -d'|' -f$i)
	PART=$(echo $PART | tr "=" "\t\t\t")
	echo $PART
done
