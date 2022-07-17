#!/usr/bin/env bash
# dependencies: gnugrep, imagemagick, xrandr, i3lock
# references: https://github.com/SammysHP/i3lockmore
pic=~/clash-configuration/lock-screen-picture
picresized=$(mktemp)

screenarea=$(xrandr --current | grep -oP '(?<=current )\d+ x \d+')
screenarea=${screenarea// /}
screens=( $(xrandr --current | grep -oP '\d+x\d+\+\d+\+\d+') )

convert -size $screenarea xc:black -quality 11 png24:"$picresized"

for screen in "${screens[@]}"; do
    convert "$picresized" \
            \( "$pic" -gravity Center -resize ${screen%%+*}^ -extent ${screen%%+*} \) \
            -gravity NorthWest -geometry +${screen#*+} -composite \
            -quality 11 png24:"$picresized"
done

exec i3lock -i "$picresized"
