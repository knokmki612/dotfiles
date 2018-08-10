#!/bin/sh
ffmpeg -i $1 -b:v 1M $(echo $1 | sed 's;\.[^.]\+$;-s.mp4;')
ffmpeg -i $1 -c:v libvpx -crf 10 -b:v 1M -c:a libvorbis $(echo $1 | sed 's;\.[^.]\+$;-s.webm;')
