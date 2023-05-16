#!/bin/sh

#xrdb -load $XDG_CONFIG_HOME/X11/xresources


## "daemons"
gnome-keyring-daemon --start
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &



## lockscreen
xset s 600 &
xss-lock --transfer-sleep-lock -- betterlockscreen -l dimblur &



# picom --experimental-backends -b &
picom -b &
playerctld daemon
nm-applet &
blueman-applet & 
companion &
# companion & disown
