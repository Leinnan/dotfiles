#!/bin/bash

while [ 1 ]
do
    luminosity=$(xbacklight)
    minimal_lumonisity=1.5
    if (( $(echo "$minimal_lumonisity > $luminosity" | bc -l) ))
    then
        xbacklight -set $minimal_lumonisity
        xbacklight +2
        echo "TOO DARK"
    else
        echo "OKAY!"
    fi
    sleep 0.5
done
