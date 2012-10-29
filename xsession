#!/bin/sh
# .xsession is called by a display manager such as xdm or gdm.
# .xinitrc is called by startx (xinit).

# load X Resource defaults
if [ -r $HOME/.Xresources ]; then
    xrdb -merge $HOME/.Xresources
fi

xsetroot -solid black &

# rebuild font.dir file
mkfontdir ~/.fonts
# add to font path
xset fp+ ~/.fonts
# tell X to reread fonts
xset fp rehash

# I did my custom stuff, now try to run the default window manager
if [ -z "$STARTUP" ]; then
    if [ -x /usr/bin/x-session-manager ]; then
        STARTUP=/usr/bin/x-session-manager
    elif [ -x /usr/bin/x-window-manager ]; then
        STARTUP=/usr/bin/x-window-manager
    elif [ -x /usr/bin/x-terminal-emulator ]; then
        STARTUP=/usr/bin/x-terminal-emulator
    elif [ -x /usr/bin/xterm ]; then
        STARTUP=/usr/bin/xterm
    fi
fi
exec $STARTUP
