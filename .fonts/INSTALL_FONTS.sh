#!/bin/sh
#
# Refresh the font cache.
# This is here mainly to support Noah's Ugly Hacker Font (NUHF).
# Example:
#    xterm -font "-fontforge-noahclear-normal-r-normal--11-80-100-100-m-70-win-0"
#
# Noah Spurrier

# print X font path:
#xset q

# rebuild font.dir file
mkfontdir ~/.fonts
# add to font path
xset fp+ ~/.fonts > /dev/null 2>&1
# tell X to reread fonts
xset fp rehash > /dev/null 2>&1
