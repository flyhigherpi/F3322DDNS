#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export f3322_`
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
LOGFILE="/tmp/upload/f3322.log"
rm -rf $LOGFILE

start_f3322(){
   
        wan_ip=$(nvram get wan0_ipaddr)
        service="http://$f3322_user:$f3322_password@members.3322.org/dyndns/update?hostname=$f3322_hostname&$wan_ip"
        wget -q -O - $service
        if [ $? -eq 0 ]; then
            /sbin/ddns_custom_updated 1
            echo_date "/sbin/ddns_custom_updated 1" >> $LOGFILE
            dbus set f3322_run="1"
        else
            /sbin/ddns_custom_updated 1
            echo_date "/sbin/ddns_custom_updated 0" >> $LOGFILE
            dbus set f3322_run="0"
        fi

    auto_start
    write_cron_job
}

stop_f3322(){
    kill_cron_job
    /sbin/ddns_custom_updated 0
    dbus set f3322_run="0"
}
auto_start() {
	echo_date "创建开机/iptable重启任务" >> $LOG_FILE
	[ ! -L "/koolshare/init.d/S101f3322.sh" ] && ln -sf /koolshare/scripts/f3322_config.sh /koolshare/init.d/S101f3322.sh
	[ ! -L "/koolshare/init.d/N101f3322.sh" ] && ln -sf /koolshare/scripts/f3322_config.sh /koolshare/init.d/N101f3322.sh
}
write_cron_job(){
    #每30分钟检查一次
    cru a f3322  "*/30 * * * * /koolshare/scripts/f3322_config.sh restart"
}
kill_cron_job() {
	if [ -n "$(cru l | grep f3322)" ]; then
		echo_date 删除f3322定时更新任务...
		sed -i '/f3322/d' /var/spool/cron/crontabs/* >/dev/null 2>&1
	fi
}

case $action in
start)
	if [ "$f3322_enable" == "1" ]; then
		echo_date "start_f3322" >> $LOGFILE
		start_f3322
	fi
	;;
restart)
	if [ "$f3322_enable" == "1" ]; then
		echo_date "start_f3322" >> $LOGFILE
		start_f3322
    else
        echo_date "stop_f3322" >> $LOGFILE
	    stop_f3322
	fi
	;;
stop)
	echo_date "stop_f3322" >> $LOGFILE
	stop_f3322
	;;
*)
	if [ "$f3322_enable" == "1" ]; then
		start_f3322
	else
		stop_f3322
	fi
	;;
esac