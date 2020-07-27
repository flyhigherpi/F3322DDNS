#!/bin/sh

source /koolshare/scripts/base.sh
eval `dbus export f3322_`

if [ "$f3322_run" -gt 0 ];then

	http_response "运行中"

else

	http_response "没启用"
fi

