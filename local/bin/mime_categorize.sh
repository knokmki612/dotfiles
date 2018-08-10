#!/bin/sh
IFS="
"
for file in $(find . -maxdepth 1 -type f); do
	mime=$(file --mime-type -b "$file" | sed 's;/x-;/;')
	mkdir -p "$mime"
	mv -i "$file" "$mime"
done
