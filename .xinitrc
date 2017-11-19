[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

mpd &
aadd &
exec bspwm
