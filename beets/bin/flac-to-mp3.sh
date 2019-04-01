#!/bin/sh
ffmpeg -i "$1" -f wav - | lame -V 2 --noreplaygain - "$2"
