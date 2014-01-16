#!/bin/bash

export DISPLAY=":0.0"
export XAUTHORITY='/home/user/.Xauthority'

level=$(cat /sys/class/backlight/acpi_video0/brightness)    
let perc=(100*$level)/15

osd_pid='/tmp/osd.pid'
osd_cmd='osd_cat --f -xos4-*-*-*-*-*-32-*-*-*-*-*-*-* -d 2 -A center -o 700 -l 2 -O 3 -u black -c green  --barmode=slider'

if [[ -f $osd_pid ]]; then kill $(cat $osd_pid) 2> /dev/null; fi

($osd_cmd --percentage=$perc --text="Brightness:$perc % ")  &
echo $! > $osd_pid

exit 0
