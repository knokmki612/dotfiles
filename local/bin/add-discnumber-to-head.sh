#!/bin/sh
find . -name '*.m4a' -o -name '*.flac' |
sed 's;^\./;;'                         |
tr '\n' '\0'                           |
xargs -0 -I{} mv {} "$1 {}"
