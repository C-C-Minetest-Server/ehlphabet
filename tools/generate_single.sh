#!/bin/bash

char="$1"
output="$2"

echo "Generating for $char"

magick -size 64x64 xc:white \
    \( -font '/usr/share/fonts/noto-cjk/NotoSansCJK-Bold.ttc' -pointsize 48 -fill black label:"$char" -trim \) \
    -gravity center -composite -colorspace gray "$output"

