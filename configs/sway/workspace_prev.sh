#!/bin/bash
WORKSPACES=$(swaymsg -t get_workspaces)
FOCUSED=$(echo "$WORKSPACES" | jq '[.[] | select(.focused)] | .[0].num')
MIN=$(echo "$WORKSPACES" | jq '[.[].num] | min')
if [ "$FOCUSED" -le "$MIN" ]; then
    swaymsg "workspace number $((MIN - 1))"
else
    swaymsg "workspace prev"
fi
