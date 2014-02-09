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

# vim:foldmethod=marker
