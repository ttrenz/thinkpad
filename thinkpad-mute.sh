#!/bin/bash 

export DISPLAY=":0.0"
export XAUTHORITY="/home/user/.Xauthority"

MUTE_STATE=`cat /proc/acpi/ibm/volume | grep -i mute:`

osd_pid='/tmp/osd.pid'
if [ -f $osd_pid ]; then kill `cat $osd_pid` 2>/dev/null; fi


if [[ $MUTE_STATE =~ ^mute:.*on ]] 
then
	if [[ -e /tmp/mute.pid ]]; then kill `cat /tmp/mute.pid`; fi
	echo "Muted" | osd_cat -d 0 -A left -i 270 -o 734 -c red -O 3 -u black -f -xos4-*-*-*-*-*-32-*-*-*-*-*-*-* &
	mute_pid=$!
	echo $mute_pid > /tmp/mute.pid
else
	if [[ -e /tmp/mute.pid ]]; then kill `cat /tmp/mute.pid`; fi
	echo mute > /proc/acpi/ibm/volume
	echo "Muted" | osd_cat -d 0 -A left -i 270 -o 734 -c red -O 3 -u black -f -xos4-*-*-*-*-*-32-*-*-*-*-*-*-* &
	mute_pid=$!
	echo $mute_pid > /tmp/mute.pid



		
fi
