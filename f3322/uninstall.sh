#!/bin/sh
eval `dbus export f3322_`
source /koolshare/scripts/base.sh


if [ "$f3322_enable" == "1" ];then
	echo_date 关闭f3322插件！
	sh /koolshare/scripts/f3322_config.sh stop
    sleep 1
fi


find /koolshare/init.d/ -name "*f3322*" | xargs rm -rf

rm -rf /koolshare/res/icon-f3322.png
rm -rf /koolshare/scripts/f3322*.sh
rm -rf /koolshare/webs/Module_f3322.asp
rm -f /koolshare/scripts/f3322_install.sh
rm -f /koolshare/scripts/uninstall_f3322.sh


dbus remove softcenter_module_f3322_install
dbus remove softcenter_module_f3322_version