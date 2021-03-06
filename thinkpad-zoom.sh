#!/bin/sh
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

# Script to trigger XF86MyComputer
# Event handling done by fluxbox keybinding, which is resizing the current window to fullscreen


test -f /usr/share/acpi-support/key-constants || exit 0

. /usr/share/acpi-support/key-constants
acpi_fakekey $KEY_COMPUTER
