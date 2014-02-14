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

exec >/dev/null 2>&1

. /usr/share/acpi-support/power-funcs
getXconsole


NUM_ID=$(amixer contents | grep "Capture Switch"| cut -d ',' -f1)
MUTE_STATUS=$(amixer cget ${NUM_ID} | sed -n 's/^  : values=//p'| cut -d ',' -f1)

if [ $MUTE_STATUS == "on" ]
then 
	amixer sset Capture nocap >/dev/null 2>&1
	echo "Microphone is now OFF" | osd_cat -d 3 -A center -o 700 -c green -f -*-terminus-*-*-*-*-32
else
	amixer sset Capture cap >/dev/null 2>&1
	echo "Microphone is now ON" | osd_cat -d 3 -A center -o 700 -c green -f -*-terminus-*-*-*-*-32
fi
