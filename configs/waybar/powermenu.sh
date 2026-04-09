#!/bin/bash
entries=" Shutdown
 Reboot
 Lock"
selected=$(echo -e $entries|fuzzel --dmenu --prompt "Power Menu> ")
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
