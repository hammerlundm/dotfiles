#!/usr/bin/bash

Clock() {
    DATETIME=$(date "+%a %b %d, %T")

    echo -n "$DATETIME"
}

Battery() {
    STAT=$(acpi -b)
    BATT=$(echo $STAT | sed 's/[^%]* \([0-9]\{1,3\}\)%.*/\1/')

    if [[ $STAT =~ "Discharging" ]]
    then
        if ((0 <= $BATT && $BATT <= 20))
        then
            echo -n "%{F#cc241d}\uf244%{F-}"
        elif ((20 <= $BATT && $BATT <= 40))
        then
            echo -n "\uf243"
        elif ((40 <= $BATT && $BATT <= 60))
        then
            echo -n "\uf242"
        elif (( 60 <= $BATT && $BATT <= 80))
        then
            echo -n "\uf241"
        elif ((80 <= $BATT && $BATT <= 100))
        then
            echo -n "\uf240"
        fi
    else
        echo -n "\uf1e6"
    fi

    echo -n "$BATT%"
}

bspwm() {
    BSPWM=$(bspc query -D)
    BUSY=$(bspc query -D -d .occupied)

    for DESK in $BSPWM
    do
        CHAR="\uf10c"
        if [[ $BUSY =~ $DESK ]]
        then
            CHAR="\uf111"
        fi
        echo -n "%{A:bspc desktop $DESK -f:}"
        if [ $DESK = $(bspc query -D -d) ]
        then
            echo -n "%{F$AC}$CHAR%{F$FG}"
        else
            echo -n "$CHAR"
        fi
        echo -n "%{A} "
    done
}

Network() {
    NET=$(netctl-auto list | grep \* | sed 's/\* \(.*\)/\1/')

    if [ -n $NET ]
    then
        echo -n "\uf1eb$NET"
    fi
}

Music() {
    NAME=$(mpc current)
    MPC=$(mpc status)

    if [[ -n $NAME ]]
    then
        PC=$(echo $MPC | grep -o "([0-9]*%)")
        PC=${PC:1:-2}
        LEN=$(echo $NAME | wc -m)
        HL=$(($PC * $LEN / 100))
        if [[ $MPC =~ "playing" ]]
        then
            echo -n "%{A:mpc pause &> /dev/null:}\uf04c%{A} "
        else
            echo -n "%{A:mpc play &> /dev/null:}\uf04b%{A} "
        fi
        echo -n "%{A:pkill -SIGUSR1 aadd:}%{+u}%{U$AC}${NAME:0:$HL}%{-u}${NAME:$HL}%{A}"
    fi
}

Volume() {
    MIXER=$(amixer get Master)
    VOL=$(echo "$MIXER" | awk -F"[][]" '/dB/ {print $2}')

    if [[ $MIXER =~ "[off]" ]]
    then
        echo -n "\uf026 "
    else
        echo -n "\uf028 "
    fi

    echo -n "$VOL"

}

while true; do
    FG=$(cat $HOME/.themes/FG)
    BG=$(cat $HOME/.themes/BG)
    AC=$(cat $HOME/.themes/AC)
    echo -e "%{F$FG}%{B$BG}%{l}$(Battery) $(Network) $(Volume)%{c}$(Clock)%{r}$(Music) $(bspwm)"
    sleep .5
done

