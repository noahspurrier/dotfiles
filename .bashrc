#
# .bashrc
#
# The universal, all purpose .bashrc script.
#
# Copyright (c) 2010, Noah Spurrier <noah@noah.org>
#

# Remember:
# NON-INTERACTIVE shells source "$BASH_ENV"
#       NON-LOGIN shells source /etc/bash.bashrc AND then ~/.bashrc
#           LOGIN shells source /etc/profile AND then source only ONE of these:
#                               ~/.bash_profile OR ~/.bash_login OR ~.profile

# if not running interactively, don't do anything
[ -z "$PS1" ] && return

# Default file permissions: rwxr-xr-x
umask 022

# Locale settings. Remember you may run `locale` to see LC_* settings.
# LANG is the master source of locale information. All LC_* variables
# will take the value of LANG if they are not already set.
export LANG=C
# LC_COLLATE is an exception no matter what locale you set.
# Most low-level systems people will usually want it set to 'C'.
# For example, if LC_COLLATE is set to "en_US.UTF-8" then a simple command
# `ls -la` will ignore dots when sorting filenames. This will cause dotfiles
# to be displayed mixed with regular files.
export LC_COLLATE=C

# The following code allows this script to be source from anywhere.
# From here on I use ${BASH_SOURCE} instead of ~/ or $HOME.
# This removes the dependency on the absolute path to
# a user's ~ home directory, so these files may be moved to other paths
# or sourced by other users. For example, sometimes an account is shared
# by multiple users, but each wants a different environment. A user may
# source this script to update their environment just for their session.
# This can even be done automatically by the LC_EXTRA_USER hack that
# follows after this SOURCE_DIR definition.
# FIXME: Mac OS X and Bash version 2.05b.0(1)-release
# FIXME: do not have the BASH_SOURCE feature.
if [ -r ${BASH_SOURCE} ] ; then
    SOURCE_DIR=`readlink -e \`dirname ${BASH_SOURCE}\``
else
    SOURCE_DIR=`readlink -e ${PWD}/\`dirname ${BASH_SOURCE}\``
fi

# The following code loads extra user environment information.
# This is a hack based on the fact that most SSH servers are configured
# to allow clients to pass locale environment variables (LC_*).
# On the client side this code will automatically assign the value of the
# USER variable to LC_EXTRA_USER which the remote server allows to pass.
# The remote server bashrc will check if LC_EXTRA_USER has been passed,
# If LC_EXTRA_USER was passed then the remote server will source an extra
# an extra environment script for that user. The user's extra environment
# info should be defined under a dot directory based on the user's name.
# Both client and server should have the following in their .bashrc files.
# The same code works, without changes, for both the client and server side.
if [ -z "${EXTRA_USER_SET}" ] ; then
    export EXTRA_USER_SET=1 # Prevent recursive import of extra .bashrc.
    if [ "${LC_EXTRA_USER}" ] ; then
        [ -r ~/.${LC_EXTRA_USER}/.bashrc ] && source ~/.${LC_EXTRA_USER}/.bashrc
    else
        export LC_EXTRA_USER=${USER}
    fi
fi

# Source /etc/bashrc -- do not confuse this with /etc/bash.bashrc
[ -r /etc/bashrc ] && source /etc/bashrc

# It sucks that there is no way to query the terminal for background color.
# COLORFGBG does not appear to be our friend here.
#export BACKGROUND='dark'

# Set the PS1 prompt.
case "${TERM}" in
    ansi*|vt10*|vt22*|cygwin*) # no color
    if [ $(id -u) -eq 0 ] ;
    then # root
        PS1='\[\033[0;7;30;31m\]\D{%s} ?=$? \u@\H:$PWD\[\033[m\]\n\$ '
    else # normal user
        PS1='\[\033[0;7m\]\D{%s} ?=$? \u@\H:$PWD\[\033[m\]\n\$ '
    fi
    ;;
    xterm*|rxvt*|screen*) # color (assume all xterms have color).
    if [ $(id -u) -eq 0 ] ;
    then # root
	PS1='\[\033]0;\H:$PWD\007\033[7;91m\]\D{%s}\[\033[31m\] \[\033[91m\]?=$?\[\033[31m\] \[\033[91m\]\u@\H:$PWD\[\033[m\]\n\$ '
    else # normal user
	PS1='\[\033]0;\H:$PWD\007\033[7;92m\]\D{%s}\[\033[2;32m\] \[\033[0;7;92m\]?=$?\[\033[2;32m\] \[\033[7;92m\]\u@\H:$PWD\[\033[m\]\n\$ '
    fi
    ;;
    *)
    PS1='\D{%s} ?=$? \u@\H:$PWD\n\$ '
    ;;
esac

# This improves the output readability of Bash scripts when '-x' is used.
# DO NOT EXPORT THIS. It will mess up POSIX shell scripts.
PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '

export EDITOR=vim
export VISUAL=vim
export VIMINIT="source ${SOURCE_DIR}/.vimrc"
export PYTHONSTARTUP="${SOURCE_DIR}/.pythonrc.py"
export SCREENRC="${SOURCE_DIR}/.screenrc"
export LESS="-R"
export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
    vim -R -c 'set ft=man nomod nolist' -c 'set mouse=a' \
    -c 'map q :q<CR>' -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""
export BROWSER=firefox
export GZIP="-9"
unset GREP_OPTIONS
case $(grep --help) in
    *'--color'*)
    export GREP_OPTIONS="--color=auto";;
    *)
    export GREP_OPTIONS="";;
esac

# Colorize directory listings. This works on both BSD and GNU.
if ls --version 2>/dev/null | grep -iq "free software foundation" ; then
    # GNU ls
    eval "$(dircolors 2>/dev/null)"
    export LS_OPTIONS="--color=auto"
else # BSD ls
    export CLICOLOR=""
fi

if ls --group-directories-first / >/dev/null 2>&1 ; then
    export LS_OPTIONS="${LS_OPTIONS} --group-directories-first"
fi

if ls --time-style / >/dev/null 2>&1 ; then
    export LS_OPTIONS="${LS_OPTIONS} --time-style=+%FT%T%:::z"
fi

# This is a BSD-ism (except for the Mac OS X variant).
#[ -x /usr/libexec/path_helper ] && eval `/usr/libexec/path_helper -s`

pathmunge ()
{
    if ! echo ${PATH} | egrep -q "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH=${PATH}:$1
        else
            PATH=$1:${PATH}
        fi
    fi
}
# Non-root users need sbin in path in order to do `sudo` completion.
[ -d /sbin ] && pathmunge /sbin after
[ -d /usr/sbin ] && pathmunge /usr/sbin after
[ -d /usr/local/sbin ] && pathmunge /usr/local/sbin after
[ -d ${SOURCE_DIR}/bin ] && pathmunge ${SOURCE_DIR}/bin after
[ -d /usr/games ] && pathmunge /usr/games after
export PATH
unset pathmunge

# This adds 'pcpu' to the format of the 'time' builtin command.
export TIMEFORMAT=$'\npcpu\t%P\nreal\t%3lR\nuser\t%3lU\nsys\t%3lS'
# Tell sysstat use ISO 8601 time format.
export S_TIME_FORMAT="ISO"

# This may seem excessive, but even with timestamps it averages only 300K.
export HISTSIZE=10000
# date and time stamps in ISO 8601 format
export HISTTIMEFORMAT="%FT%T "
export HISTIGNORE="history:h:hg:nohist:miv:.dotfiles"
# Ignore duplicate adjacent lines and lines that start with space.
export HISTCONTROL=ignoreboth
# Allow editing of multi-line commands.
shopt -s cmdhist
# Multiple shells append to history file rather than overwriting each other.
# Append each session's history prior to issuing each primary prompt.
# See http://www.ukuug.org/events/linux2003/papers/bash_tips/.
shopt -s histappend
export PROMPT_COMMAND='history -a'

# Do not echo control characters such as ^C, ^X, ^Z.
# It makes cut-and-paste annoying if you didn't notice that
# that the terminal echoed the ^C in the output you copied.
stty -echoctl
# Don't exit shell on CTRL-D.
set -o ignoreeof
# Check the window size after each command and if necessary
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
## # Allow '.dotfiles" to be returned in path-name expansion.
## shopt -s dotglob
# Turn on extended globbing.
shopt -s extglob
# Do not do completion on an empty command-line.
shopt -s no_empty_cmd_completion

# Silence the console bell.
if type setterm >/dev/null 2>/dev/null; then
    setterm -blength 0
fi

# If running X11 then change some settings.
if [ "${DISPLAY}" ] && which xset >/dev/null ; then
    # Silence the X11 terminal bell.
    xset b off >/dev/null 2>&1
    # Add user's fonts to font path. Ignore errors if they don't have one.
    xset fp+ ${SOURCE_DIR}/.fonts >/dev/null 2>&1
    ## # reload X11 .Xresources
    ## [ -r ${SOURCE_DIR}/.Xresources ] && xrdb -merge ${SOURCE_DIR}/.Xresources >/dev/null 2>&1
fi

[ -r /etc/bash_completion ] && source /etc/bash_completion

# Source aliases and functions. See also ~/bin for user scripts and tools.
[ -r ${SOURCE_DIR}/.bash_aliases ] && source ${SOURCE_DIR}/.bash_aliases

# Put all settings that are specific to this machine in .bashrc_local.
# This allows all machines to use an identical .bashrc that may be
# upgraded without the need to check for local modifications.
[ -r ${SOURCE_DIR}/.bashrc_local ] && source ${SOURCE_DIR}/.bashrc_local

# This should really be put in ${SOURCE_DIR}/.bashrc_local if necessary.
## # LD_LIBRARY_PATH is sometimes a necessary evil.
## export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/local/lib/mysql

# Put the following section in ${SOURCE_DIR}/.bashrc_local only
# if you want your dotfiles to be automatically updated every 7 days you login.
## # This gets the latest dotfiles if the installer is older than 7 days.
## # Oh man, are you sure? This might be a bad idea...
## # TODO should also test age of tarball on server.
## BASHRC_AGE_IN_SECS=$[`date +%s` - `stat -c %Y ${SOURCE_DIR}/.dotfiles_install`]
## if [ $BASHRC_AGE_IN_SECS -gt 604800 ]; then
##     echo "UPDATING DOTFILES"
##     (${SOURCE_DIR}/.dotfiles 2>&1 >/dev/null) &
## fi

#
# END OF SCRIPT .bashrc
#

## if [ -n "$BASH_VERSION" ]; then
##     # Bash programmable completion.
##     shopt -s progcomp
##     # I could put 'scp' in this list but most of the time I use scp to
##     # copy a local file to a remote host, so it's more important to
##     # complete on a local filename rather than a hostname.
##     complete -A hostname ssh telnet ftp ping fping host dig nmap
##     complete -A hostname ping telnet rsh ssh slogin rlogin traceroute nslookup ftp fping host dig nmap
##     export HOSTFILE=/etc/hosts
##     complete -A helptopic help
##     complete -A directory mkdir rmdir cd du find pushd run-parts
##     complete -A file -X '!*.?(t)bz?(2)' bunzip2 bzcat bzcmp bzdiff bzegrep bzfgrep bzgrep
##     complete -A file -X '!*.@(zip|ZIP|egg|jar|JAR|exe|EXE|pk3|war|wsz|ear|zargo|xpi|sxw|ott)' unzip zipinfo
##     complete -A file -X '!*.deb' dpkg dpkg-deb debi gdebi gdebi-gtk lintian
##     #complete -A file -X '*.Z' compress znew
##     #complete -A file -X '!*.@(Z|gz|tgz|Gz|dz)' gunzip zcmp zdiff zcat zegrep zfgrep zgrep zless zmore
##     #complete -A file -X '!*.@(Z|gz|tgz|Gz|bz2|tar)' tar
##     #complete -A file -X '!*.Z' uncompress
##     complete -A file -X '!*.@(gif|jp?(e)g|tif?(f)|png|p[bgp]m|bmp|x[bp]m|rle|rgb|pcx|fits|pm|GIF|JPG|JP?(E)G|TIF?(F)|PNG|P[BGP]M|BMP|X[BP]M|RLE|RGB|PCX|FITS|PM)' xv zgv xzgv d
##     #complete -A file -X '!*.@(@(?(e)ps|?(E)PS|pdf|PDF)?(.gz|.GZ|.bz2|.BZ2|.Z))' gv ggv kghostview
##     #complete -A file -X '!*.@(dvi|DVI)?(.@(gz|Z|bz2))' xdvi
##     #complete -A file -X '!*.@(dvi|DVI)' dvips dviselect dvitype kdvi dvipdf advi
##     #complete -A file -X '!*.@(pdf|PDF)' acroread gpdf xpdf kpdf
##     #complete -A file -X '!*.@(?(e)ps|?(E)PS)' ps2pdf
##     #complete -A file -X '!*.texi*' makeinfo texi2html
##     #complete -A file -X '!*.@(?(la)tex|?(LA)TEX|texi|TEXI|dtx|DTX|ins|INS)' tex latex slitex jadetex pdfjadetex pdftex pdflatex texi2dvi
##     complete -A file -X '!*.@(mp3|MP3)' mpg123 mpg321 music123 madplay pla
##     complete -A file -X '!*.@(mp?(e)g|MP?(E)G|wma|avi|AVI|asf|vob|VOB|bin|dat|vcd|ps|pes|fli|flv|viv|rm|ram|yuv|mov|MOV|qt|QT|wmv|mp3|MP3|ogg|OGG|ogm|OGM|mp4|MP4|wav|WAV|asx|ASX|mng|MNG)' xine kaffeine pla
##     #complete -A file -X '!*.@(mpg|mpeg|avi|mov|qt)' xanim
##     complete -A file -X '!*.@(ogg|OGG|m3u|flac|spx)' ogg123
##     #complete -A file -X '!*.@(mp3|MP3|ogg|OGG|pls|m3u)' gqmpeg freeamp
##     #complete -A file -X '!*.fig' xfig
##     complete -A file -X '!*.@(exe|EXE|com|COM|scr|SCR|exe.so)' wine
##     #complete -A file -X '!*.@(?([xX]|[sS])[hH][tT][mM]?([lL]))' netscape mozilla lynx opera galeon curl dillo elinks amaya moz
##     # user commands see only users
##     complete -A user su sux login groups usermod userdel passwd chage chsh chfn slay w write talk
##     # group commands see only groups
##     [ -n "$bash205" ] && complete -A group groupmod groupdel newgrp 2>/dev/null
##     # job commands
##     complete -A job -P '%' fg jobs disown
##     # bg job command completes only with stopped jobs
##     complete -A stopped -P '%' bg
##     # readonly and unset complete with shell variables
##     complete -A variable readonly unset
##     # set completes with set options
##     complete -A setopt set
##     # complete shopt options
##     complete -A shopt shopt
##     # complete aliases
##     complete -A alias alias unalias
##     #
##     # complete commands that run other commands
##     # (I'm not sure both flavors are necessary. This needs some cleanup.)
##     # There are two flavors...
##     # ...commands that run other commands and CWD files (scripts).
##     complete -A command -A file nohup eval exec type nice time env sudo watch strace dtrace ltrace ktrace truss gdb runcon
##     # ...commands that run other commands only (never scripts).
##     # 'man' is a compromise because it will not complete on all man pages.
##     complete -A command type command which whatis whereis apropos man
##     # builtin completes on builtins
##     complete -A builtin builtin
## fi

