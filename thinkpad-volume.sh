#!/bin/bash  
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


export DISPLAY=":0.0"
export XAUTHORITY='/home/user/.Xauthority'


headphone_status() { #{{{
NUMID=$(amixer contents | grep -iw "name='Headphone Jack'" | cut -d ',' -f1)
if [ `amixer cget $NUMID | sed -n '/values=[on|off]/p' | cut -d '=' -f 2` == 'values=off' ]
then
# Headphone is not plugged
return 0
else
# Headphone is plugged
return 1
fi
} #}}}

case $1 in
up)
    mixer_option='5+';;
down)
    mixer_option='5-';;
*)
    exit 1;;
esac


volume_percent=$(amixer get Master,0 | sed -ne '/^.*Front Left/s/.*\[\(.*\)%\].*/\1/p')

MUTE_STATE=`cat /proc/acpi/ibm/volume | grep -i mute:`



if [[ -e /tmp/mute.pid ]]
then
	echo unmute > /proc/acpi/ibm/volume
	kill `cat /tmp/mute.pid`
	amixer set Master,0 $mixer_option > /dev/null
else
	amixer set Master,0 $mixer_option > /dev/null
fi


osd_pid='/tmp/osd.pid'
osd_cmd='osd_cat --f -xos4-*-*-*-*-*-32-*-*-*-*-*-*-* -d 2 -A center -o 700 -l 2 -O 3 -u black -c green  --barmode=slider'

if [[ -f $osd_pid ]]; then kill $(cat $osd_pid) 2> /dev/null; fi
($osd_cmd --percentage=$volume_percent --text="Master Volume:$volume_percent % ") &
echo $! > $osd_pid


# vim:foldmethod=marker
