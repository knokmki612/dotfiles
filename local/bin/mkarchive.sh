#!/bin/sh
tar czvf "$(date -r "$1" '+%Y%m%d')_$(basename "$1").tar.gz" "$1"
