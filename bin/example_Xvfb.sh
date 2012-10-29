#!/bin/sh

# This is a simple example of using Xvfb. This can be used for automatically
# getting screen snapshots for documentation or testing.
#
# Noah Spurrier 2006 $Id: example_Xvfb.sh 273 2008-07-26 02:54:01Z root $

# The most common beginner mistake is to forget about X access control. The -ac
# option is documented in Xserver(1x) This disables access control. You could
# also use '-auth' which is also documented in Xserver(1x).

# xwud seems to have problems with pixel depth other than 8, so that's why I
# use x8 in the screen spec. Note that '-screen' spec actually includes the
# space after 0 in '-screen 0 320x240x8', so don't try to put any options
# between the '0' and the '3'.
Xvfb :666.0 -screen 0 320x240x8 -fbdir /tmp -ac &

sleep 2 # Give Xvfb time to startup

xclock -update 1 -display :666.0 &

sleep 2 # Give xclock time to startup

# Note that xwud does not update. It displays a snapshot.
xwud -in /tmp/Xvfb_screen0 &

sleep 5 # let the second hand move a bit
# You can make snapshots simply by copying /tmp/Xvfb_screen0 to another file.
cp /tmp/Xvfb_screen0 /tmp/snapshot.wud
xwud -in /tmp/snapshot.wud &

sleep 1
rm /tmp/snapshot.wud
