#!/usr/bin/awk -f
BEGIN {
	for (i=1;i<1000;i++) print val+=rand() - 0.5
}
