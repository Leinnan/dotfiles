#!/bin/bash
echo "    "$(xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) _NET_WM_NAME | grep -oP '(?<=").*?(?=")')
