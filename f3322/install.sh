#! /bin/sh

# shadowsocks script for HND/AXHND router with kernel 4.1.27/4.1.51 merlin firmware

source /koolshare/scripts/base.sh
eval $(dbus export f3322_)
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
MODEL=$(nvram get productid)

mkdir -p /tmp/upload
sleep 2s
# 判断路由架构和平台
case $(uname -m) in
	aarch64)
		if [ "$(uname -o|grep Merlin)" ] && [ -d "/koolshare" ];then
			echo_date 固件平台【koolshare merlin aarch64 / merlin_hnd】符合安装要求，开始安装插件！
		else
			echo_date 本插件适用于【koolshare merlin aarch64 / merlin_hnd】固件平台，你的平台不能安装！！！
			rm -rf /tmp/f3322* >/dev/null 2>&1
			exit 1
		fi
		;;
	armv7l)
		if [ "`uname -o|grep Merlin`" ] && [ -d "/koolshare" ] && [ -n "`nvram get buildno|grep 384`" ];then
			echo_date 固件平台【koolshare merlin armv7l 384】符合安装要求，开始安装插件！
		else
			echo_date 本插件适用于【koolshare merlin armv7l 384】固件平台，你的固件平台不能安装！！！
			echo_date 退出安装！
			exit 1
		fi
		;;
	*)
		echo_date 本插件适用于koolshare merlin aarch64固件平台，你的平台：$(uname -m)不能安装！！！
		echo_date 退出安装！
		rm -rf /tmp/f3322* >/dev/null 2>&1
		exit 1
	;;
esac

if [ "$MODEL" == "GT-AC5300" ] || [ "$MODEL" == "GT-AX11000" ] || [ -n "$(nvram get extendno | grep koolshare)" -a "$MODEL" == "RT-AC86U" ];then
	# 官改固件，骚红皮肤
	ROG=1
fi

#if [ "$MODEL" == "TUF-AX3000" ];then
	# 官改固件，橙色皮肤
#	TUF=1
#fi

# 先关闭clash
if [ "$f3322_enable" == "1" ];then
	echo_date 先关闭F3322ddns，保证文件更新成功!
	[ -f "/koolshare/scripts/f3322_config.sh" ] && sh /koolshare/scripts/f3322_config.sh stop
fi


# 检测储存空间是否足够
echo_date 检测jffs分区剩余空间...
SPACE_AVAL=$(df|grep jffs | awk '{print $4}')
SPACE_NEED=$(du -s /tmp/f3322 | awk '{print $1}')
if [ "$SPACE_AVAL" -gt "$SPACE_NEED" ];then
	echo_date 当前jffs分区剩余"$SPACE_AVAL" KB, 插件安装需要"$SPACE_NEED" KB，空间满足，继续安装！
	#升级前先删除无关文件,保留已上传配置文件
	echo_date 清理旧文件,保留已上传配置文件
	rm -rf /koolshare/scripts/f3322_config.sh
	rm -rf /koolshare/scripts/f3322_status.sh
	rm -rf /koolshare/webs/Module_f3322*
	rm -rf /koolshare/res/icon-f3322.png

	find /koolshare/init.d/ -name "*f3322.sh" | xargs rm -rf

	echo_date 开始复制文件！
	cd /tmp

	echo_date 复制相关的脚本文件！
	cp -rf /tmp/f3322/scripts/* /koolshare/scripts/
	cp -rf /tmp/f3322/install.sh /koolshare/scripts/f3322_install.sh
	cp -rf /tmp/f3322/uninstall.sh /koolshare/scripts/uninstall_f3322.sh

	echo_date 复制相关的网页文件！
	cp -rf /tmp/f3322/webs/* /koolshare/webs/
	cp -rf /tmp/f3322/res/* /koolshare/res/

	echo_date 为新安装文件赋予执行权限...
	chmod 755 /koolshare/scripts/f3322*


	echo_date 创建一些二进制文件的软链接！
	[ ! -L "/koolshare/init.d/S101f3322.sh" ] && ln -sf /koolshare/scripts/f3322_config.sh /koolshare/init.d/S101f3322.sh
	[ ! -L "/koolshare/init.d/N101f3322.sh" ] && ln -sf /koolshare/scripts/f3322_config.sh /koolshare/init.d/N101f3322.sh

	# 离线安装时设置软件中心内储存的版本号和连接
	CUR_VERSION="0.0.1"
	dbus set f3322_version_local="$CUR_VERSION"
	dbus set softcenter_module_f3322_install="1"
	dbus set softcenter_module_f3322_version="$CUR_VERSION"
	dbus set softcenter_module_f3322_title="F3322 DDNS"
	dbus set softcenter_module_f3322_description="F3322 DDNS"

	echo_date 一点点清理工作...
	rm -rf /tmp/f3322* >/dev/null 2>&1

	echo_date F3322-DDNS插件安装成功！
	
	if [ "$f3322_enable" == "1" ];then
		echo_date 重启f3322插件！
		sh /koolshare/scripts/f3322_config.sh start
	fi

	echo_date 更新完毕，请等待网页自动刷新！
else
	echo_date 当前jffs分区剩余"$SPACE_AVAL" KB, 插件安装需要"$SPACE_NEED" KB，空间不足！
	echo_date 退出安装！
	exit 1
fi

