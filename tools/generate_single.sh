#!/bin/bash

char="$1"
output="$2"
font="$3"

echo "Generating for $char"

magick -size 64x64 xc:none \
    \( -background none -font "$font" -pointsize 48 -fill black label:"$char" -trim \) \
    -gravity center -composite -colorspace gray "$output"

