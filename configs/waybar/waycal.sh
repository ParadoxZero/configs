#!/bin/sh

if pkill -x waycal; then
    echo '{"text": "", "class": ""}'
else
    waycal --position top-left &
    echo '{"status": "active", "class": "active"}'
fi
