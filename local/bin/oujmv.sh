#!/bin/sh
if [ ! -f "$1" ]; then
	echo "no such file"
	exit 1
fi
html="$1"

for sbjnum in $(grep -oE '[0-9]{7}' "$html" | uniq); do
	for pdf in $(ls -f | grep -E "$sbjnum-[0-9]{4}[aq]\.pdf"); do
		sbjname=$(
			grep "$sbjnum" "$html" |
			sed 's;.*nowrap>\([^<]\+\)</TD>.*;\1;g' |
			tr -d \')
		echo "found: $sbjname"
		mv "$pdf" $(echo "$pdf" | sed "s;[0-9]\{7\};$sbjname;")
	done
done

exit
