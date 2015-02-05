#!/bin/sh

DIFF_TOOL=diff
if which colordiff > /dev/null; then
    DIFF_TOOL=colordiff
fi


function ask() {
  echo -e -n "\e[1;37m$2\e[0m ${3} "
  read $1
}

function ask_yesno() {
    ask YESNO "$1" "[y/N]"
    if [[ $YESNO == 'y' ]]; then
        return 0
    fi
    return 1
}

function check-sudo() {
    if [[ ! $UID -eq 0 || -z ${SUDO_USER} ]]; then
        log ERR "sudo required but $0 is not started with"
        log ABORT "Run it with 'sudo $0'"
        exit 2
    fi
}


###############################################################################
### Notification and logging functions                                      ###
###############################################################################

function log() {
    local LEVEL=${1^^}
    shift

    #console output only behind this line
    local MSG="\e[0;33m[$(date "+%H:%M:%S")] -${VENT}-${ENV}-\e[0m "

    case ${LEVEL^^} in
        ERROR|ERR|FATAL|ABORT|FAILED)
            echo -e "$MSG [\e[01;31m${LVL_PREFIX^^}${LEVEL^^}\e[0m] -- $*" 1>&2
        ;;
        SUDO|SUDOER|SU|INSTALL|SETUP)
            echo -e "$MSG [\e[01;36m${LVL_PREFIX^^}${LEVEL^^}\e[0m] -- $*" 1>&2
        ;;
        WARN)
            echo -e "$MSG [\e[01;33m${LVL_PREFIX^^}${LEVEL^^}\e[0m] -- $*" 1>&2
        ;;
        DONE|SUCCESS|FINISH|FINISHED)
            echo -e "$MSG [\e[00;32m${LVL_PREFIX^^}${LEVEL^^}\e[0m] -- $*" 1>&2
        ;;
        *)
            echo -e "$MSG [\e[01;34m${LVL_PREFIX^^}${LEVEL^^}\e[0m] -- $*"
        ;;
    esac
}
