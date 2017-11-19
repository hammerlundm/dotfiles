#!/bin/bash
if [ $# -eq 1 ]
then
    if [ $1 == "list" ]
    then
        DIRS=$(ls -d $HOME/.themes/*/ -1)
        for D in $DIRS
        do
            echo $D | cut -d '/' -f 5
        done
    elif [ -d $HOME/.themes/$1 ] || [ $1 == "random" ]
    then
        if [ $1 == "random" ]
        then
            DIRS=($HOME/.themes/*/)
            DIR=${DIRS[RANDOM % ${#DIRS[@]}]}
        else
            DIR=$HOME/.themes/$1
        fi
        # Change files
        rm -f $HOME/.themes/FG $HOME/.themes/BG $HOME/.themes/AC $HOME/.vim/colors.vim $HOME/.config/termite/config $HOME/.themes/rofi $HOME/.wallpaper
        ln $DIR/FG $HOME/.themes/FG
        ln $DIR/BG $HOME/.themes/BG
        ln $DIR/AC $HOME/.themes/AC
        ln $DIR/colors.vim $HOME/.vim/colors.vim
        ln $DIR/termite $HOME/.config/termite/config
        ln $DIR/wallpaper.jpg $HOME/.wallpaper
        ln $DIR/rofi $HOME/.themes/rofi
        # Reload terminals
        CURR=$(xdotool getactivewindow)
        TERMS=$(xdotool search --class termite)
        for TERM in $TERMS
        do
            xdotool windowactivate $TERM 2> /dev/null
            xdotool key ctrl+shift+r
        done
        # Reload vim
        VIMS=$(xdotool search --name vim)
        for VIM in $VIMS
        do
            if [[ $TERMS =~ $VIM ]]
            then
                xdotool windowactivate $VIM 2> /dev/null
                xdotool key Escape
                xdotool key ctrl+r
            fi
        done
        xdotool windowactivate $CURR
        # Reload wallpaper
        hsetroot -fill $HOME/.wallpaper
    else
        echo "$1 is not a theme" >&2
    fi
else
    echo "Usage: ${0##*/} name" >&2
fi

