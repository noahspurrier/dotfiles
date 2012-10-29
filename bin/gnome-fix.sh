#!/bin/bash

if [ "${MY_UID}" = "0" ]; then
	aptitude install gvim
	sed -i -e "s/gedit/gvim/" /usr/share/applications/defaults.list

	for cache_dir /usr/share/icons/*; do sudo gtk-update-icon-cache -f ${cache_dir}; done
fi

if type gconftool-2 >/dev/null 2>&1; then
	gconftool-2 --type=string --set /apps/compiz/general/allscreens/options/toggle_window_maximized_horizontally_key '<Control><Alt>h'
	gconftool-2 --type=string --set /apps/compiz/general/allscreens/options/toggle_window_maximized_vertically_key '<Control><Alt>v'
	gconftool-2 --type=string --set /apps/compiz/general/allscreens/options/show_desktop_key '<Control><Alt>d'
fi

