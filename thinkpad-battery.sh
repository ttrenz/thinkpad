#!/bin/bash 
# Written by: Thomas Trenz <ttrenz@web.de>

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
# http://www.gnu.org/copyleft/gpl.html

if [ -f /usr/share/acpi-support/power-funcs ]
then
	. /usr/share/acpi-support/power-funcs
fi
getXconsole
#export XAUTHORITY="/home/user/.Xauthority"

AC_STATUS=$(cat /sys/class/power_supply/AC/online)

use_smapi(){ #{{{

declare power=();
for file in /sys/devices/platform/smapi/BAT*/power_avg
 do
	if [ -e $file ]
	then
		raw_power=`cat $file 2>/dev/null` 
		if [ -n $raw_power   ]
		then
        	power=("${power[@]}" $raw_power)
		fi
	else
		logger -t acpid $0 "File $file not found"
	fi

done
count=${#power[*]}
for((i=0;i<$count;i++))
do 
                sum_power=$(( $sum_power+${power[$i]} ))  
done


declare time=();
for time_file in /sys/devices/platform/smapi/BAT*/remaining_running_time
 do
	if [ -e $time_file ]
	then
		raw_time=`cat $time_file 2>/dev/null`
		if [ -n $raw_time ]
		then		
		time=("${time[@]}" $raw_time)
		fi
	else
		echo "Failed"
		break
	fi
done

count=${#time[*]}
for((i=0;i<$count;i++))
do
                sum_time=$(( $sum_time+${time[$i]} ))  
done

hours=$(($sum_time/60))
mins=$(($sum_time-$hours*60))
POWER=$(echo "scale=2;$sum_power * -1 / 1000" | bc)
TIME="$hours:`printf %02d $mins`"
} #}}}

use_acpi() { #{{{
power_file='/sys/class/power_supply/BAT0/power_now'
raw_power=`cat $power_file`
POWER=$(echo "scale=2;$raw_power / 1000000" | bc)
TIME=`acpi | cut -d "," -f 3 | cut -d " " -f 2`
} #}}}

display_osd() { #{{{

osd_pid='/tmp/osd.pid' # 

if [ -e $osd_pid ];then kill $(cat $osd_pid) 2> /dev/null; fi

if [ -d /sys/devices/platform/smapi ] ; then
	use_smapi
else
	use_acpi
fi
echo -e "Time remaining : ${TIME} h \nCurrent Power usage: ${POWER} W" | osd_cat -d 2 -A center -o 730 -w --age=1  -c green -l 1 -O 3 -u black -f -xos4-*-*-*-*-*-32-*-*-*-*-*-*-* &
echo $! > $osd_pid
} #}}}

display_ac() { #{{{
echo -e "AC Adapter is attached" | osd_cat -d 2 -A center -o 730 -w --age=1  -c green -l 1 -O 3 -u black -f -xos4-*-*-*-*-*-32-*-*-*-*-*-*-* &
} #}}}


if [ $AC_STATUS -eq "0" ]
then
display_osd
else
display_ac
fi 

exit 0

# vim:foldmethod=marker
