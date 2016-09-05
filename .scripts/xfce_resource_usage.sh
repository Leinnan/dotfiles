#!/bin/bash


output="<txt>"
readonly next="ttttttttttttttttttttttttttt"

readonly secondary_color="#007dD9"
readonly warning_color="#FFDC00"
readonly error_color="#FF4136"

##########################
# DEADBEEF
########################## 

is_deadbeef_running=$(ps cax | grep deadbeef | wc -l)
if [ $is_deadbeef_running  -gt 0  ]; then
	deadbeef_status=$(deadbeef --nowplaying '%a- %t')
	output="$output<span weight=\"heavy\" fgcolor=\"$secondary_color\">MP3</span> $deadbeef_status$next"
fi


##########################
# MPD
########################## 


mpd_title=$(mpc | head -1)
mpd_status=$(mpc | head -2 | tail -1)

if grep -q "playing" <<< "$mpd_status" ; then
    output="$output<span weight=\"heavy\" fgcolor=\"$secondary_color\">MPD</span> $mpd_title$next"
elif grep -q "paused" <<< "$mpd_status" ; then
    output="$output<span weight=\"heavy\" fgcolor=\"$secondary_color\">MPD</span> $mpd_title <span fgcolor=\"$warning_color\">[paused]</span>$next"
fi



##########################
# Battery
########################## 

if [ $(ls /sys/class/power_supply | grep BAT | wc -l) -gt 0 ]; then
    battery_directory="/sys/class/power_supply/"$(ls /sys/class/power_supply | grep BAT | head -1)"/"
    energy_now=$(<$battery_directory"/charge_now")
    energy_full=$(<$battery_directory"/charge_full")
    battery_color=""
    charge=$(($energy_now*100))
    charge=$(($charge/$energy_full))
    
#    if [ "90" -gt "$charge" ]; then
#        battery_color="color=\"da2818\""
#        output=$output"DSADAS"
#    fi
    
    status=$(<$battery_directory"/status")
    charge="<span weight=\"heavy\" fgcolor=\"$secondary_color\" $battery_color>BAT</span> "$charge"%"
    output="$output$charge$next"
fi



##########################
# RAM
########################## 
freememory=$(free | tail -2 | head -1 | awk '{print $3/$2 * 100.0}' | awk '{printf("%d\n",$1 + 0.5)}' )
freememory="<span weight=\"heavy\" fgcolor=\"$secondary_color\">RAM</span> $freememory%"
output="$output$freememory$next"

##########################
# CPU
########################## 

cpu_usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage }' | awk '{printf("%d\n",$1 + 0.5)}' )
cpu_usage="<span weight=\"heavy\" fgcolor=\"$secondary_color\" >CPU</span> $cpu_usage%"
output="$output$cpu_usage$next"


hdd_free=$(df --output=avail -h / |  tail -n 1 | tr -d ' ')
if [[ $hdd_free == *"G"* ]]
then
    hdd_free=$(echo $hdd_free | sed 's/G/ GB/g')
fi
if [[ $hdd_free == *"M"* ]]
then
    hdd_free=$(echo $hdd_free | sed 's/M/ MB/g')
fi
hdd_free="<span weight=\"heavy\" fgcolor=\"$secondary_color\">HDD</span> "$hdd_free

output="$output$hdd_free$next"

##########################
# DATE
########################## 

date_without_month=$(date +"%H:%M, %d")

month=$(date +"%m")
set_month_roman=false


if $set_month_roman
then
    case "$month" in
      "01") month="I" ;;
      "02") month="II" ;;
      "03") month="III" ;;
      "04") month="IV" ;;
      "05") month="V" ;;
      "06") month="VI" ;;
      "07") month="VII" ;;
      "08") month="VIII" ;;
      "09") month="IX" ;;
      "10") month="X" ;;
      "11") month="XI" ;;
      "12") month="XII" ;;
      *) month="XD"
    esac
else
    case "$month" in
      "01") month="stycznia" ;;
      "02") month="lutego" ;;
      "03") month="marca" ;;
      "04") month="kwietnia" ;;
      "05") month="maja" ;;
      "06") month="czerwca" ;;
      "07") month="lipca" ;;
      "08") month="sierpnia" ;;
      "09") month="września" ;;
      "10") month="października" ;;
      "11") month="listopada" ;;
      "12") month="grudnia" ;;
      *) month="nietzschego"
    esac
fi

output="$output$date_without_month $month$next"






output=$(echo $output | sed 's/'$next'/   •   /g' | sed 's/&/and/g')
output=${output::-7}"</txt>"




echo -e "$output"

