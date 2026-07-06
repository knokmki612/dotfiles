#!/bin/sh
rsync -rltDv --exclude="*.flac" "/var/run/media/$USER/External/Music/Album/" "/var/run/media/$USER/WALKMAN/MUSIC/"
