#!/bin/bash
#
#
# This is free software; you may redistribute it and/or modify
# it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2,
# or (at your option) any later version.
#
# This is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License with
# the Debian operating system, in /usr/share/common-licenses/GPL;  if
# not, write to the Free Software Foundation, Inc., 59 Temple Place,
# Suite 330, Boston, MA 02111-1307 USA
#

### BEGIN INIT INFO
# Provides:          netcat
# Required-Start:    $network $local_fs $remote_fs 
# Required-Stop:     $network $local_fs $remote_fs 
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Netcat Test Daemon
### END INIT INFO

. /lib/lsb/init-functions

# Source optional arguments
if [ -r /etc/default/netcat ]; then
    source /etc/default/netcat
fi 

do_start(){
    log_daemon_msg "Starting Netcat Test Daemon" "netcat"
    start-stop-daemon \
        --start \
        --quiet \
        --pidfile /var/run/netcat.pid \
        --name `basename /bin/nc` \
        --startas /bin/nc \
        --chuid ryan \
        --background \
        --make-pidfile \
        -- \
        -l 12345 $OPTIONAL_START_ARGUMENTS \
        || log_progress_msg "already running"
    log_end_msg 0
}

do_stop(){
    log_daemon_msg "Stopping Netcat Test Daemon" "netcat"
    start-stop-daemon \
        --stop \
        --quiet \
        --pidfile /var/run/netcat.pid \
        --name `basename /bin/nc` \
        --retry TERM/5/TERM/5
        RES=$?
        if [ $RES -eq 1 ]; then
            log_progress_msg "not running"
        fi
        if [ $RES -eq 2 ]; then
            log_progress_msg "not responding to TERM signals"
        fi
        if [ -f /var/run/netcat.pid ]; then
            log_progress_msg "(removing stale PID file)"
            rm /var/run/netcat.pid
        fi
        log_end_msg 0
}

do_reload(){
    log_daemon_msg "Reloading Netcat Test Daemon" "netcat"
    if ! start-stop-daemon \
        --stop --quiet \
        --pidfile /var/run/netcat.pid \
        --name `basename /bin/nc` \
        --signal 1; then
        log_progress_msg "not running."
    fi
    log_end_msg 0
}

do_status(){
     status_of_proc -p /var/run/netcat.pid /bin/nc netcat && exit 0 || exit $?
}

case "$1" in
    start)
        do_start
        ;;
    stop)
        do_stop
        ;;
    restart)
        do_stop
        do_start
        ;;
    reload)
        do_reload
        ;;
    force-reload)
        do_reload
        ;;
    status)
        do_status
        ;;
    *)
        echo "Usage: /etc/init.d/netcat {start|stop|restart|reload|force-reload|status}"
        exit 1
        ;;
esac

exit 0 
