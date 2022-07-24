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
exec i3lock-color -i "$picresized"\
     --pass-{media,volume,power,screen}-keys\
     --line-color=ffffff00 --separator-color=ffffff22\
     --{time,date,verif,wrong,modif,greeter,ring}-color=ffffffcc\
     --{ringwrong,bshl}-color=ff397ecc --{ringver,keyhl}-color=39ff37cc\
     --inside{,ver,wrong}-color=001534c7 --radius=9 --ring-width=2.0\
     --date-str= --time-str="%F %H:%M" --force-clock\
     --{verif,wrong,lock,lockfailed,noinput,greeter}-text= --no-modkey-text\
     --ind-pos="x+w-228:y+h-32"  --time-pos="x+w-24:y+h-24" --time-align=2\
     --{verif,wrong,greeter}-size=20 --time-size=24
