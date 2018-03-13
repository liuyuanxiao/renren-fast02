#!/bin/bash
##############################################
# Author: netkiller<netkiller@msn.com>
# Homepage: http://www.netkiller.cn
# Date: 2017-02-08
# $Author$
# $Id$
##############################################
# chkconfig: 345 100 02
# description: Spring boot application
# processname: springbootd
# File : springbootd
##############################################
BASEDIR="/www/netkiller.cn/api.netkiller.cn"
JAVA_HOME=/srv/java
JAVA_OPTS="-server -Xms2048m -Xmx8192m -Djava.security.egd=file:/dev/./urandom"
PACKAGE="api.netkiller.cn-0.0.2-release.jar"
CONFIG="--spring.config.location=$BASEDIR/application.properties"
USER=www
##############################################
NAME=springbootd
PROG="$JAVA_HOME/bin/java $JAVA_OPTS -jar $BASEDIR/$PACKAGE $CONFIG"
LOGFILE=/var/tmp/$NAME.log
PIDFILE=/var/tmp/$NAME.pid
ACCESS_LOG=/var/tmp/$NAME.access.log
##############################################

function log(){
	echo "$(date -d "today" +"%Y-%m-%d %H:%M:%S") $1	$2" >> $LOGFILE
}

function start(){
	if [ -f "$PIDFILE" ]; then
		echo $PIDFILE
		exit 2
	fi

	su - $USER -c "$PROG & echo \$! > $PIDFILE"
	log info start
}
function stop(){
	[ -f $PIDFILE ] && kill `cat $PIDFILE` && rm -rf $PIDFILE
	log info stop
}
function status(){
	ps aux | grep $PACKAGE | grep -v grep | grep -v status
	log info status
}
function reset(){
	pkill -f $PACKAGE
  	[ -f $PIDFILE ] && rm -rf $PIDFILE
	log info reset
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	status)
		status
		;;
	restart)
		stop
		start
		;;
	log)
		tail -f $LOGFILE
		;;
	reset)
		reset
		;;
	*)
		echo $"Usage: $0 {start|stop|status|restart|log|reset}"
esac
exit $?