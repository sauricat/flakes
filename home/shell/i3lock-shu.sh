#!/usr/bin/env bash
# dependencies: gnugrep, procps, imagemagick, xrandr, i3lock-color, onboard, feh
# references: https://github.com/SammysHP/i3lockmore

pic=~/clash-configuration/lock-screen-picture
picresized=$(mktemp)
picresizedhint=$(mktemp)

screenarea=$(xrandr --current | grep -oP '(?<=current )\d+ x \d+')
screenarea=${screenarea// /}
screens=( $(xrandr --current | grep -oP '\d+x\d+\+\d+\+\d+') )

convert -size $screenarea xc:black -quality 11 png24:"$picresized"

if [[ $# -ge 1 && $1 == "--grace-mode" ]]
then
    for screen in "${screens[@]}"
    do
        convert "$picresized" \
                \( "$pic" -gravity Center -resize ${screen%%+*}^ -extent ${screen%%+*} \
                -font DejaVu-Sans -fill white -stroke black -pointsize 96 -strokewidth 2 \
                -draw "text 5,5 'Locking... Press [q]/[x] to relieve.'" \) \
                -gravity NorthWest -geometry +${screen#*+} -composite \
                -quality 11 png24:"$picresized"
    done
else
    for screen in "${screens[@]}"
    do
        convert "$picresized" \
                \( "$pic" -gravity Center -resize ${screen%%+*}^ -extent ${screen%%+*} \) \
                -gravity NorthWest -geometry +${screen#*+} -composite \
                -quality 11 png24:"$picresized"
    done
fi

if [[ $# -ge 1 && $1 == "--grace-mode" ]]
then
    feh --fullscreen --auto-zoom "$picresized" &
    pidfeh=$!
    sleep $2
    kill $!
    exit
fi

existsonboard=nil
if [[ -n $(pgrep onboard) ]]
then
    onboard-toggle
    existsonboard=0
fi
i3lock-color -i "$picresized" \
             --pass-{media,volume,power,screen}-keys \
             --line-color=ffffff00 --separator-color=ffffff22 \
             --{time,date,verif,wrong,modif,greeter,ring}-color=ffffffcc \
             --{ringwrong,bshl}-color=ff397ecc --{ringver,keyhl}-color=39ff37cc \
             --inside{,ver,wrong}-color=001534c7 --radius=9 --ring-width=2.0 \
             --date-str= --time-str="%F %H:%M" --force-clock \
             --{verif,wrong,lock,lockfailed,noinput,greeter}-text= --no-modkey-text \
             --ind-pos="x+w-228:y+h-24" \
             --time-pos="x+w-24:y+h-16" --time-align=2 \
             --{verif,wrong,greeter}-size=20 --time-size=24 &
if [[ $(hostname) == "iwkr" ]]
then
    onboard &
    pidonboardnew=$!
    while [[ -n $(pgrep i3lock-color) ]]
    do
        sleep 0.5
    done
    if [[ $existsonboard == "nil" ]]
    then
        onboard-toggle
    fi
fi
