#!/bin/bash
#!/usr/bin/env bash

######################################################################
#
# This is a Bash shell script template.
#
# SYNOPSIS
#
#     TODO helloworld [-h] [-v,--verbose] [--version]
#
# DESCRIPTION
#
#     TODO This script needs a description of what it does.
#
# EXAMPLES
#
#     TODO The following are some examples of how to use this script.
#
# EXIT STATUS
#
#     TODO This exits with status 0 on success or non-zero on error.
#
# AUTHOR
#
#     TODO Noah Spurrier <noah@noah.org>
#
# LICENSE
#
#     This license is approved by the OSI and FSF as GPL-compatible.
#         http://opensource.org/licenses/isc-license.txt
#
#     TODO Copyright (c) 2019, Noah Spurrier <noah@noah.org>
#     PERMISSION TO USE, COPY, MODIFY, AND/OR DISTRIBUTE THIS SOFTWARE FOR ANY
#     PURPOSE WITH OR WITHOUT FEE IS HEREBY GRANTED, PROVIDED THAT THE ABOVE
#     COPYRIGHT NOTICE AND THIS PERMISSION NOTICE APPEAR IN ALL COPIES.
#     THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
#     WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
#     MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
#     ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
#     WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
#     ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
#     OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#
# VERSION
#
#     TODO Version 1
#
######################################################################

get_realpath() {
    if [ -d "$1" ]; then
        cd "$1"
    else
        if [ "${1}" != "${1%/*}" ]; then
            cd "${1%/*}"
        fi
    fi
    realpath="$(pwd -P)"
    cd - >/dev/null
    if [ -d "$1" ]; then
        echo "${realpath}"
    else
        echo "${realpath}/${1##*/}"
    fi
    return 0
}

# This sets variables which record where the script was started from and
# where the script itself is installed.
PWD="$(pwd)"
START_DIRECTORY="${PWD}"
if [ -x "$0" ]; then
    COMMAND="$(get_realpath "$0")"
else
    COMMAND="$(get_realpath "${PWD}/$0")"
fi
INSTALLDIR="$(dirname "${COMMAND}")"

######################################################################
# Debug
######################################################################

# This makes the debug output of `set +x` (set -o xtrace) easier to read.
# DO NOT export this. It will crash POSIX shell subshells and scripts.
[ -n "${BASH}" ] && PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '

# set -o trace xtrace
## Do not allow use of unset variables.
#set -o nounset
## Exit script if it does not catch an error from any command it runs.
## For example, this will exit the script:
##     false
## This will not exit the script
##     if false; then echo "This will never be printed."; fi
#set -o errexit

# Color stderr output red. I think this may alter order of stdin/stderr output.
exec 3>&2
exec 2> >(sed -u 's/^\(.*\)$/'$'\e''[31m\1'$'\e''[m/' >&3)

#####################################################################
# Color
#####################################################################

# Don't use color if there is no terminal on stdout.
if type tput >/dev/null 2>/dev/null && tty <&1 >/dev/null 2>&1; then
    COLOR_RED="$(tput setaf 1)"
    COLOR_GRN="$(tput setaf 2)"
    COLOR_BLU="$(tput setaf 4)"
    COLOR_YEL="$(tput setaf 3)"
    COLOR_OFF="$(tput sgr0)"
else
    COLOR_RED=""
    COLOR_GRN=""
    COLOR_BLU=""
    COLOR_YEL=""
    COLOR_OFF=""
fi

# This attempts to standardize possible exit status codes.
# This is from the BSD include file, /usr/include/sysexits.h
EX_OK=0            # successful termination
EX__BASE=64        # base value for error messages
EX_USAGE=64        # command line usage error
EX_DATAERR=65      # data format error
EX_NOINPUT=66      # cannot open input
EX_NOUSER=67       # addressee unknown
EX_NOHOST=68       # host name unknown
EX_UNAVAILABLE=69  # service unavailable
EX_SOFTWARE=70     # internal software error
EX_OSERR=71        # system error (e.g., can't fork)
EX_OSFILE=72       # critical OS file missing
EX_CANTCREAT=73    # can't create (user) output file
EX_IOERR=74        # input/output error
EX_TEMPFAIL=75     # temp failure; user is invited to retry
EX_PROTOCOL=76     # remote error in protocol
EX_NOPERM=77       # permission denied
EX_CONFIG=78       # configuration error
EX__MAX=78         # maximum listed value

#####################################################################
# Log
#####################################################################

# This demonstrates printing and logging output at the same time.
# This works by starting `tee` in the background with its stdin
# coming from a named pipe that we make; then we redirect our
# stdout and stderr to the named pipe. All pipe cleanup is handled
# in a trap at exit. IMPORTANT! If you add an exit trap of your own
# be sure that it calls on_exit_trap cleanup somewhere in your
# trap handler.

# This is the exit trap handler for the 'tee' logger.
on_exit_trap_cleanup () {
    # Tell `tee` we are done by closing our end of the pipe.
    exec 1>&- 2>&-
    # Wait for `tee` process to finish. If we exited before `tee`
    # then it might be killed before it was done flushing its buffers.
    wait ${TEEPID}
    rm ${PIPEFILE}
}

tee_log_output () {
    LOGFILE=$1
    PIPEFILE="$(mktemp -u $(basename $0)-pid$$-pipe-XXX)"
    mkfifo "${PIPEFILE}"
    tee "${LOGFILE}" < "${PIPEFILE}" &
    TEEPID=$!
    # Redirect subsequent stdout and stderr output to named pipe.
    exec > "${PIPEFILE}" 2>&1
    trap on_exit_trap_cleanup EXIT
}

#####################################################################
# Exit cleanup
#####################################################################

exit_with_message() {
    local EXIT_CODE="${1:-0}"
    local EXIT_MESSAGE="${2:-''}"

    # Exit with error will print to stderr and highlight in red.
    if [ "${EXIT_CODE}" != "0" ]; then
        exec 1>&2
        # TODO Print synopsis of command.
        echo "This script may do something useful."
        echo
        echo "Usage: $0 [-h | --help]"
        echo "  -h --help         : Shows this help."
        echo
        echo "${COLOR_RED}"
    fi
    echo "${EXIT_MESSAGE}"
    echo "${COLOR_OFF}"
    exit ${EXIT_CODE}
}

#####################################################################
# Global traps and aliases
#####################################################################

# Must set 'die' as an alias in order for LINENO to make sense.
shopt -s expand_aliases
alias die='echo -n "${COLOR_YEL}${0} at line ${LINENO}:${COLOR_OFF} "; exit_with_message'

trap "die 1 'Received SIGHUP'" SIGHUP
trap "die 1 'Received SIGINT'" SIGINT
trap "die 1 'Received SIGTERM'" SIGTERM

#####################################################################
# MAIN
#####################################################################

LOGFILE="$0-$$.log"
tee_log_output ${LOGFILE}
echo "######################################################################"
date "+# start time  : %F %T%:::z (epoch %s)"
echo "# command     : ${INSTALLDIR}/$0"
echo "# pid         : $$"
echo "# output log  : $(pwd)/${LOGFILE}"
echo "######################################################################"
echo

if [ $# -le 0 ]; then
    die 2 "Not enough arguments."
fi


#
# Some introns.
#
#NEW_HOSTNAME=${1:?ERROR: Missing new hostname parameter.}

##
## Prerequisite checks
##
#if [ $(id -u) -ne 0 ]; then
#    echo "ERROR: You must be root to run this script." >&2
#    echo "Perhaps you forgot to use sudo." >&2
#    exit 1
#fi
#
#
#if [ ! -r /root/.ssh/id_rsa ]; then
#    /usr/bin/ssh-keygen -q -N '' -f /root/.ssh/id_rsa
#fi
#
#echo
#echo "# Setup basic readline input handling (/etc/inputrc)."
#cat > /etc/inputrc <<"EOF_INPUTRC"
#"\e[A": history-search-backward
#"\e[B": history-search-forward
#"\e[2~": quoted-insert
#"\e[3~": delete-char
#"\e[1~": beginning-of-line
#"\e[4~": end-of-line
#set show-all-if-ambiguous on
#set show-all-if-unmodified on
#set completion-query-items -1
#set skip-completed-text on
#set page-completions off
#set print-completions-horizontally on
#$if bash
#    set expand-tilde on
#    set match-hidden-files off
#    set visible-stats on
#    set completion-ignore-case on
#    set mark-directories on
#    set mark-symlinked-directories on
#$endif
#EOF_INPUTRC

#echo
#echo "# Allow sudo for all in admin group."
#echo >> /etc/sudoers
#echo "%admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo
date "+# end time  : %F %T%:::z (epoch %s)"
echo "######################################################################"

die 0 "This is a script template that just prints this message."

######################################################################
# END
#########1#########2#########3#########4#########5#########6#########7
#
#  __________________            _-_
#  \___=NCC-1701= __))  ____.---'---`---.____
#              \_ \     \----._________.----'
#                \ \     / /    `-_-'
#            __,--`-`---'-'-.
#           /}___           ){-
#                `--.____,-'
#
#       __Q-_            _______====-
#      {====---=========/_____    /___
#       `----'          `---- `\___, /
#                             _/___/_____
#                            <__________|}
#
# vim:set ft=sh sr et ts=4 sw=4 : // See Vim, :help 'modeline'

