#!/bin/bash
# http://northernmost.org/blog/find-out-what-is-using-your-swap/
# Get current swap usage for all running processes
# Erik Ljungstrom 27/05/2011

#export LC_NUMERIC="en_US.UTF-8"

SUM=0
OVERALL=0

get_username() {
    uid=$1
    if [ -z $uid ];then
        username="NA"
    else
        username=$(getent passwd $Uid | awk -F: '{print $1}')
    fi
    echo $username
}

get_swap(){
   
    show_all=$1
    
    for DIR in `find /proc/ -maxdepth 1 -type d | egrep "^/proc/[0-9]"` ; do

        SWAP=$(grep VmSwap $DIR/status 2> /dev/null | awk '{print $2}')

        if [[ -z "$SWAP" ]]; then
            continue
        fi
    
        PID=`echo $DIR | cut -d / -f 3`
        PROGNAME=$(ps -p $PID -o comm --no-headers 2>/dev/null)
        cmdline=$(cat $DIR/cmdline 2>/dev/null | strings -1)
        Uid=$(awk '/^Uid:/{print $2}' $DIR/status 2> /dev/null)
        USERNAME=$(get_username $Uid)
        CMDLINE=$(echo $(IFS= ;echo "${cmdline[*]}"))

        if [ $show_all ];then
            echo -e "${USERNAME::20}\t PID: ${PID}\t - Swap used: $SWAP kB\t ${PROGNAME}\t ${CMDLINE}"
        else
            echo $SWAP
            if [ "$SWAP" != "0" ]; then
                echo -e "${USERNAME::20}\t PID: ${PID}\t - Swap used: $SWAP kB\t ${PROGNAME}\t ${CMDLINE}"
            fi
        fi
    
    done 
}

case $1 in 
    -a|--all)
        get_swap true;;
    *)
       get_swap;;
esac

