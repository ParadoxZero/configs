#!/bin/bash
entries=" Shutdown
 Reboot
 Lock"
selected=$(echo -e $entries|wofi --dmenu --prompt "Power Menu" --width 250 --height 200)
case $selected in
  " Shutdown")
    systemctl poweroff
    ;;
  " Reboot")
    systemctl reboot
    ;;
  " Lock")
    swaylock
    ;;
esac
