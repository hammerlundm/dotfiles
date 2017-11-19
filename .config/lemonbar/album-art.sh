#!/bin/bash
ARTIST=$(mpc current -f "%albumartist%")
ALBUM=$(mpc current -f "%album%")

if [[ -n $FEH ]] && [[ -n $(ps -o pid= -p $FEH) ]]
then
    disown $FEH
    kill -9 $FEH
    export FEH=""
else
    bspc rule -a feh state=floating sticky=on rectangle=600x600+2600+30 -o
    feh -q "$HOME/Music/$ARTIST/$ALBUM"/cover.* -g 600x600 2>/dev/null &
    export FEH=$!
fi

