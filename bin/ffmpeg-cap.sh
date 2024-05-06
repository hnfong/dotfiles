#!/bin/bash

# This script takes a video file as an argument and captures a frame every 5 seconds.

for ((min=0;min<60;min++)); do
    for sec in 00 05 10 15 20 25 30 35 40 45 50 55; do
        ffmpeg -ss "$min":"$sec" -i "$1" -frames:v 1 -q:v 2 "$1"-"$min"."$sec".jpg
    done
done
