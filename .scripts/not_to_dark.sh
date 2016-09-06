#!/bin/bash
float_scale=2
function float_cond()
{
    local cond=0
    if [[ $# -gt 0 ]]; then
        cond=$(echo "$*" | bc -q 2>/dev/null)
        if [[ -z "$cond" ]]; then cond=0; fi
        if [[ "$cond" != 0  &&  "$cond" != 1 ]]; then cond=0; fi
    fi
    local stat=$((cond == 0))
    return $stat
}

while [ 1 ]
do
    jasnosc=$(xbacklight)
    ##if [ $jasnosc -lt 10.0 ]
    if float_cond '10.5 > $jasnosc'
    then
        xbacklight -set 10.5
        echo "TOO DARK"
    fi
    sleep 0.5
done
