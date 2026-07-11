#!/bin/sh
if pkill -x waycal; then
    echo '{"text": "", "class": ""}'
else
    waycal &
    echo '{"status": "active", "class": "active"}'
fi
