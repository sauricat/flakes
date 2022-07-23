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
exec i3lock-color --indicator --force-clock -i "$picresized"\
     --pass-{media,volume,power,screen}-keys\
     --line-color=ffffff00 --separator-color=ffffff22\
     --{time,date,verif,wrong,modif,greeter}-color=ffffffcc\
     --ring-color=902ce0cc --{ringver,keyhl}-color=397effcc --{ringwrong,bshl}-color=ff2f37cc\
     --inside-color=000000cc --insidever-color=000000cc --insidewrong-color=000000cc\
     --date-str= --time-str="%F %H:%M"\
     --{verif,wrong,lock,lockfailed,noinput,greeter}-text= --no-modkey-text\
     --ind-pos="x+w/2:y+h/2" --time-pos="ix:iy+10"\
     --{verif,wrong,greeter}-size=20 --time-size=16
