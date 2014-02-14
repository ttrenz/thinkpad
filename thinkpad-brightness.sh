#!/bin/bash
# Written by Thomas Trenz <ttrenz@web.de>

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

if [ -e /usr/share/acpi-support/power-funcs ]
then
. /usr/share/acpi-support/power-funcs
else
	echo "This scripts depends on acpi-support"
fi

getXconsole


level=$(cat /sys/class/backlight/acpi_video0/brightness)    
let perc=(100*$level)/15

osd_pid='/tmp/osd.pid'
osd_cmd='osd_cat --f -xos4-*-*-*-*-*-32-*-*-*-*-*-*-* -d 2 -A center -o 700 -l 2 -O 3 -u black -c green  --barmode=slider'

if [[ -f $osd_pid ]]; then kill $(cat $osd_pid) 2> /dev/null; fi

($osd_cmd --percentage=$perc --text="Brightness:$perc % ")  &
echo $! > $osd_pid

exit 0

# vim:foldmethod=marker
