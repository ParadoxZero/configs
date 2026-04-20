#!/bin/bash
WORKSPACES=$(swaymsg -t get_workspaces)
FOCUSED=$(echo "$WORKSPACES" | jq '[.[] | select(.focused)] | .[0].num')
MAX=$(echo "$WORKSPACES" | jq '[.[].num] | max')
if [ "$FOCUSED" -ge "$MAX" ]; then
    swaymsg "workspace number $((MAX + 1))"
else
    swaymsg "workspace next"
fi
