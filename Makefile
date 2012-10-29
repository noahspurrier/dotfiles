all:
	- rm dotfiles.tar.gz
	- chown -R ${USER} .
	- chmod 755 .subversion
	- find .subversion -type d -exec chmod 755 {} \;
	- chmod 755 .vim
	- find .vim -type d -exec chmod 755 {} \;
	- chmod 755 .fonts
	- find .fonts -type d -exec chmod 755 {} \;
	- chmod 755 .pixmaps
	- find .pixmaps -type d -exec chmod 755 {} \;
	- chmod 755 bin
	- find bin -type d -exec chmod 755 {} \;
	- chmod 600 .auth.bfa
	- chmod 600 .auth.aes
	- chmod 700 .mutt
	- chmod 700 .screen
	- chmod 700 tmp
	- chmod 644 .bashrc .bash_profile .bash_aliases .vimrc .pythonrc.py .inputrc .Xmodmap .Xresources .lynxrc .mailcap .screenrc
	- chmod 755 .dotfiles*
	tar --verbose --numeric-owner --owner 0 --group 0 --exclude=.svn -cz -f dotfiles.tar.gz .dotfiles .dotfiles_install .dotfiles_postinstall .bashrc .bash_profile .bash_aliases .aptitude .vimrc .pythonrc.py .inputrc .Xmodmap .Xresources .gtkrc-2.0 .lynxrc .htoprc .screenrc .mutt .mplayer .mailcap .fonts .subversion .pixmaps .screen .gitconfig .vim tmp bin .notes .notes.d bin/gnome-fix.sh
	md5sum dotfiles.tar.gz | sed -s "s/\([0-9a-zA-Z]*\).*/\\1/" > dotfiles.tar.gz.md5
	- chmod 644 dotfiles.tar.gz*
