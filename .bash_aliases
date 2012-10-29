# .bash_aliases

# Reminder:
# alias        : list all aliases.
# declare      : list all functions and variables.
# set          : list all functions and variables.
# declare -F   : list all function names.
# declare -f   : list all function names and definitions.
# type -a NAME : list everywhere NAME is found
#                (alias, keyword, function, builtin, file).

unalias -a
alias ls='ls $LS_OPTIONS'
# This adds octal permissions to `ls` output. This does not handle setuid, setgid, and sticky bits.
alias l='ls $LS_OPTIONS --color -la | awk "{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(\"%0o \",k);print}"'
alias ll='ls $LS_OPTIONS -lab --file-type'
alias lm='ls -am'
alias lld='ls -lad */'
alias latr='ls $LS_OPTIONS -latrF'
#alias l='ls $LS_OPTIONS -la|grep --color=never ^d;ls $LS_OPTIONS -la|grep --color=never -v ^d'
#alias l='ls $LS_OPTIONS -la|grep ^d;ls $LS_OPTIONS -la|grep -v ^d'
alias ..='cd ..'
# Like `cd` but if a filename is given then this will cd into the directory
# that holds the file. This is helpful when cutting and pasting filenames
# to cd into. This avoids the nuisance where you cut and paste a filename
# with a path and then have to delete the filename portion to cd into.
cdf () {
        if [ -d "$1" ]; then
                cd "$1";
        else
                cd $(dirname "$1");
        fi;
}
alias pd='pushd'
alias fd='pushd'
alias bd='popd'
alias pop='popd'
alias df='df -hT'
alias lspcil='lspci -v -b -k -nn -D'
alias lspcit='lspci -v -b -k -nn -t'
alias cmi='./configure && make && make install'
alias h='history 200'
alias nohist='set +o history'
alias delhist='set +o history;history -c;history -w;clear'
alias shred='shred --iterations=1'
alias j='jobs -l'
alias c='clear'
# show the devices modified in the last 5 minutes.
alias lastdevs='find /dev -mmin -5 -maxdepth 2'
# This adds "god mode" -- an homage to Doom. Hopefully I don't perform my
# sysadmin chores the same way I played Doom. This uses `sux` which is a
# wrapper around su that adds X Window forwarding. It's easy to find.
alias god='if which sux >/dev/null ; then sudo `which sux` - ; elif which sudo >/dev/null ; then sudo `which su` - ; else su - ; fi'
alias root='if which sux >/dev/null ; then sudo `which sux` - ; elif which sudo >/dev/null ; then sudo `which su` - ; else su - ; fi'
# ps grep
alias psg='ps axwwo pid,ppid,nice,pri,pcpu,pmem,stat,etime,user,command | grep -i -e "^[[:space:]]*PID" -e'
alias sleepers='ps Haxwwo stat,pid,ppid,user,wchan:25,command | grep -e "^STAT" -e "^D" -e "^Z" -e "^S"'
alias http-serve='python -m SimpleHTTPServer 8080'
# history grep
alias hg='history | grep -i'
alias memsizes='ps haxwwo vsize,pcpu,user,pid,command | sort -n && echo "   VSZ %CPU USER       PID COMMAND"'
alias iwbest='iwlist scanning 2>/dev/null | grep -e "Address" -e "ESSID" -e "Quality" | sed '\''N;s/\n/ /;h;s/^.*$//;n;G;s/\n/ /;s/[ \t]\+/ /g;s/^ //;s/:/: /'\'' | sort --key=2 --numeric --reverse | head'
# Semi-secure vim. Note that readonly is set by default.
alias miv='vim -c "set viminfo= noswapfile readonly"'
# Semi-secure password safe.
alias auth='vim ~/.auth.aes'
alias rot13='tr a-zA-Z n-za-mN-ZA-M'
alias agent='exec ssh-agent bash'
alias ssh-del='ssh-add -d'
alias vpnup='sudo openvpn --script-security 2 --config ~/.openvpn/client.conf --writepid ~/.openvpn/openvpn.pid --daemon'
alias vpndown='sudo kill -INT `cat ~/.openvpn/openvpn.pid`'
alias ban='iptables -I INPUT -j DROP -s'
alias unban='iptables -D INPUT -j DROP -s'
alias netstat='netstat -p'
alias listeners='netstat -nlp --protocol=inet'
alias mtrr='mtr -n -r -c 5'
alias suicide='kill -9 `ps --no-headers $$ | awk "{print $1}"`'
alias bc='bc --mathlib --quiet'
alias vba='vba -1 --auto-frameskip'
alias gba='vba -1 --auto-frameskip'
alias xmame='xmame -rompath .'
# tail every likely log file in /var/log
alias logs='find /var/log -type f | grep -v -E -e '\''\.gz$'\'' -e '\''\.log\.[0-9]+$'\'' -e '\''\.[0-9]+\.log$'\'' -e '\''\.[0-9]+$'\'' | xargs file | grep -e '\''text'\'' -e '\''empty'\'' | cut -d'\'' '\'' -f1 | sed -e '\''s/:$//g'\'' | xargs tail --follow=name --retry -v | sed -e '\''s/^\(==.*==\)$/\x1b[0;7m\1\x1b[m/'\'''

# These assume a USB-to-serial adapter named /dev/ttyUSB0 or /dev/ttyS0 with
# serial line settings of 8N1. The syntax for settings is the same as that used
# by the `stty` command.
#         cs8: 8-bit characters
#     -parenb: disable parity generation and detection
#     -cstopb: Use one stop bit per character
#      -hupcl: Do not hang up connection on last close
serial () {
        SPEED=${1}
        SERIAL_DEVICE=${2:-GUESS}
	if [ -z "${SPEED}" ]; then
		echo "You must specify a speed."
		echo "Common speeds are:"
		echo "    300 9600 19200 38400 57600 115200"
		return 1
	fi
	if [ "${SERIAL_DEVICE}" = "GUESS" ]; then
		if [ -c /dev/ttyUSB0 ]; then
			SERIAL_DEVICE=/dev/ttyUSB0
		elif [ -c /dev/ttyS0 ]; then
			SERIAL_DEVICE=/dev/ttyS0
		else
			echo "Could not find a serial device."
			echo "Tried /dev/ttyUSB0 first, then /dev/ttyS0."
			echo "Specify the serial device as the second option."
			return 1
		fi
	fi
        SCREEN_OPTS="${SERIAL_DEVICE} ${SPEED},cs8,parenb,-cstopb,-hupcl"
        screen -t "${SCREEN_OPTS}" ${SCREEN_OPTS}
}
alias serialwatch='watch -n 1 cat /proc/tty/driver/serial'
alias test-drive-speed-old='dd if=/dev/zero of=test_data.bin oflag=dsync conv=fdatasync  bs=8388608 count=16 2>&1 | grep "bytes" | cut -f1,6 -d" " | awk '\''{printf ("write-speed: %7.2f MB/s, ", $1 / $2 / (1024*1024))}'\'' && dd if=test_data.bin iflag=direct conv=fdatasync of=/dev/null bs=8388608 count=16 2>&1 | grep "copied" | cut -f1,6 -d" " | awk '\''{printf ("read-speed:  %7.2f MB/s\n", $1 / $2 / (1024*1024))}'\'''
alias whatismyip='curl -s checkip.dyndns.org|cut -d / -f 3|rev|awk '\''{print $1;}'\''|colrm 1 1|rev'
alias aln='arp-scan -localnet'
alias filtermac='grep -E --only-matching -e "([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}" -e "([[:xdigit:]]{1,2}-){5}[[:xdigit:]]{1,2}"'
alias filtertypescript='sed -r -e "s/.\x08//g" -e "s/\x1B\].+\x07//g" -e "s/\x1B\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K|A|@]//g" -e "s/\x0D//g" -e "s/.\x08//g" -e "s/\x07//g" -e "s/.\x08//g"'
alias note="vim -c 'normal G' -c 'startinsert!' -c ':set paste' ~/`date "+note-%Y%m%d.txt"`"
alias xr='xrdb -merge ~/.Xresources'
alias mute='amixer set Master mute'
alias pla='mplayer -af volnorm=2'
alias jpegs2mpeg='mencoder "mf://*.jpg" -mf fps=25 -ovc lavc -lavcopts vcodec=mpeg4 -o '
# For Mac OSX put in .bashrc_local:
# alias pla='/Applications/VLC.app/Contents/MacOS/VLC'
alias im='centerim -a'
alias moz='mozilla-firefox'
# This dumps CD/DVD ISO image files to stdout.
alias cddump='dd if=/dev/sr0 bs=2048 count=`isosize -d 2048 /dev/sr0` conv=notrunc,noerror 2>/dev/null'
# This dumps a directory tree in ISO format directly to stdout.
# For example, use `cdgen $HOME | cdburn`.
# This does not check the resulting ISO size!
alias cdgen='genisoimage -quiet -iso-level 3 -J -force-rr -l -N -d -allow-leading-dots -allow-multidot -V "`date --rfc-3339=seconds`" -r '
# This reads CD/DVD ISO images from stdin and burns them to the default burner.
alias cdburn='cdrecord -waiti fs=64m gracetime=4 speed=16 padsize=63s -tao -isosize -eject -'
# Subversion shortcuts.
alias svnll='svn log --limit 1 --verbose'
alias svnid='svn propset svn:keywords Id'
alias svneol='svn propset svn:eol-style native'
alias svnx='svn propset svn:executable ON'
alias svnwhat='svn merge --dry-run -r BASE:HEAD .'
alias t='if which urxvt >/dev/null ; then (urxvt &) ; elif which rxvt >/dev/null ; then (rxvt &) ; elif which xterm >/dev/null ; then (xterm &) ; fi'
#alias t="xterm -geometry 80x24+10+10 -sb -rightbar -sl 2000 -bg black -fg green -fn -fontforge-proggycleanszbp-normal-r-normal--11-80-100-100-m-70-win-0"
#alias lamify='find . -name "*.wav" -exec lame -f -a -m m -h -b 8 "{}" "{}.mp3" \; -exec rm "{}" \;'
alias lamify='find . -name "*.wav" -exec lame -f -a -m m -h -b 8 "{}" "{}.mp3" \;'
alias saidar='saidar -c'

#
# Shell Functions
#
# The following are functions, not aliases.
# I put them in this file because they serve a similar role.
# To show a list of the function names run this:
#     declare -F
# To show a list of the function definitions run this:
#     declare -f
#

# Encrypt or decrypt a given file using AES encryption with ASCII encoding.
enc () { openssl aes-256-cbc -a -e -salt -in "$1" -out "$1.aes"; }
dec () { openssl aes-256-cbc -a -d -in "$1" -out "${1%%.aes}"; }

# SSH directly to an existing or new screen session.
sshscreen () { ssh -t $* "screen -DR"; }

# Start VNC Viewer with a tunnel to REMOTE_HOST.
# This assumes VNC Server is running on REMOTE_HOST.
# Usage: sshvnc username@REMOTE_HOST port
sshvnc () {
    local HOST=$1; local PORT=$2;
    if [ ${PORT-0} -lt 10 ]; then PORT=`expr $PORT + 5900`; fi;
    ssh -f -N -q -L ${PORT}:127.0.0.1:${PORT} ${HOST}
    vncviewer 127.0.0.1:${PORT}:0;
} 

###############################################################################
# This allows a screen session to do X11 and SSH auth forwarding.
# See http://www.jukie.net/~bart/conf/zsh.d/S51_screen
#
##_ssh_auth_save() { ln -sf "$SSH_AUTH_SOCK" "$HOME/.screen/ssh-auth-sock.$HOSTNAME" }
##alias screen='_ssh_auth_save; export HOSTNAME=$(hostname); screen'
[ -z "$HOSTNAME" ] && export HOSTNAME=$(hostname)
# preserve the X environment variables
store_display() {
    export | grep '\(DISPLAY\|XAUTHORITY\)=' > ~/.display.${HOSTNAME}
}
# read out the X environment variables
update_display() {
    [ -r ~/.display.${HOSTNAME} ] && source ~/.display.${HOSTNAME}
}
# WINDOW is set when we are in a screen session
if [ -n "$WINDOW" ] ; then 
    # update the display variables right away
    update_display

    # setup the preexec function to update the variables before each command
    preexec () {
        update_display
    }
fi
# reset the ssh-auth-sock link and screen display file before we run screen
_screen_prep() {
    if [ "$SSH_AUTH_SOCK" != "$HOME/.screen/ssh-auth-sock.$HOSTNAME" ] ; then
        ln -fs "$SSH_AUTH_SOCK" "$HOME/.screen/ssh-auth-sock.$HOSTNAME"
    fi
    store_display
}
alias screen='_screen_prep ; screen'
# End screen session forwarding for X11 and SSH Auth.
###############################################################################

# Swap two filenames, if they exist (from Uzi's bashrc).
function swap()
{
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "ERROR swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "ERROR swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "ERROR swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

xd () {
    xxd -g 1 $1 | sed "n;n;n;n;n;n;n;n;n;n;n;n;n;n;n;a #"
}
alias hd='xd'

# Dates and times
# See also the script, date-rfc-3339.
epoch () {
    date "+%s" "$@"
}

epoch-to-rfc-3339 () {
    EPOCH=$(echo $@ | sed -n "s/.*\([0-9]\{10\}\).*/\1/p")
    date "+%FT%T:::%z" -d "1970-01-01 UTC ${EPOCH} seconds"
}

readc ()
{
	previous_stty=$(stty -g)
	stty raw -echo
	char=`dd bs=1 count=1 2>/dev/null`
	stty "${previous_stty}"
	if [ -n "$1" ] ; then
		eval $1="${char}"
	else
		REPLY="${char}"
	fi
}

ruler ()
{
	for row in $(seq 24 -1 2); do
		echo -n $row
		if [ "${row}" != "2" ]; then
			echo
		fi
	done

	echo -n "        1"
	for decs in $(seq 2 8); do
		echo -n "         ${decs}"
	done
	echo

	for mult in $(seq 1 8); do
		for col in $(seq 1 9); do
			echo -n ${col}
		done
		echo -n 0
	done
	readc
	echo
}

one-random-dot()
{
	printf "\033[%d;%dH\033[7;9%dm \033[m" \
		$((RANDOM%LINES+1)) \
		$((RANDOM%COLUMNS+1)) \
		$((RANDOM%8))
}

random-dots()
{
	clear;while :;do one-random-dot; sleep .001;done
}

ramdisk ()
{
    size=${1:-256}
    mount_point=${2:-"/tmp/ramdisk"}
    mkdir --mode=777 ${mount_point}
    mount -t tmpfs size=${size}M tmpfs ${mount_point}
}

dirsizes ()
{
    cd "${1:-.}"
    du -ks * | sort -n -b | column -t
}

dircounts ()
{
    cd "${1:-.}"
    for dp in *; do [ -d "${dp}" ] && echo $(find "${dp}"|wc -l) "$dp"; done | sort -n -b | column -t
}

# Similar to `dirsizes` but also recursively follows the biggest subpath.
dirsizes-max ()
{
	root_path="${1:-.}"
	if [ -d "${root_path}" ]; then
		biggest_subpath=$(cd "${root_path}"; du -ks * | sort -n -b | column -t | tail -n 1 )
		echo ${biggest_subpath}
		biggest_subpath="${biggest_subpath##* }"
		export biggest_subpath=$(readlink -e "${root_path}/${biggest_subpath}")
		if [ "${root_path}" != "${biggest_subpath}" ]; then
			dirsizes-max "${biggest_subpath}"
		fi
	fi
}

# Similar to `dircounts` but also recursively follows the biggest subpath.
dircounts-max ()
{
	root_path="${1:-.}"
	if [ -d "${root_path}" ]; then
		biggest_subpath=$(cd "${root_path}"; for dp in *; do [ -d "${dp}" ] && echo $(find "${dp}"|wc -l) "${dp}"; done | sort -n -b | column -t | tail -n 1 )
		echo "${biggest_subpath}"
		biggest_subpath="${biggest_subpath##* }"
		export biggest_subpath=$(readlink -e "${root_path}/${biggest_subpath}")
		if [ "${root_path}" != "${biggest_subpath}" ]; then
			dircounts-max "${biggest_subpath}"
		fi
	fi
}

# I'm trying to eliminate aliases that add defaults to existing commands. This
# hides what a command does by default and can make you forget how the command
# originally behaved. I will allow some exceptions, such as 'ls' being 'ls
# $LS_OPTIONS'. Some of these aliases are just not important or are not used. I
# originally added a few of these just so I had a reference place. For example,
# I would always forget that `realpath` is just `readline -f`. Some commands
# are not important enough that I would care if I learn a non-standard default,
# but my custom defaults can usually be put in a more appropriate spot. For
# example, the standard `gnuplot` does not enable persist, which has always
# annoyed me, but it really belongs in .Xresource.

#alias gnuplot='gnuplot -persist'
#alias realpath='readlink -f'
#alias aptitude='aptitude -sfD install && aptitude'
#alias irc='irc -b'
#alias cpan='perl -MCPAN -e shell'
#alias vobcopy='vobcopy --large-file'
#alias rkhunter='rkhunter -c -sk --quiet'

# END OF .bash_aliases
