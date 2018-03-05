#!/bin/bash
for u in $(grep -v "^#" /etc/passwd | cut -d : -f1)
do
	line=$(grep "^$u:" /etc/passwd)
	h=$(echo $line | cut -d: -f6)
	og=$(stat -c '%U|%G' $h)
	p=$(stat -c '%A' $h | cut -c2-)
	echo "$u: $h ($o|$g) [$p]" 2>/dev/null 
done
