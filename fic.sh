#!/bin/sh
# FakeInChina(假装在中国) 
# 用途：与“由于版权限制，你所在的地区不能播放”告别，目前支持大多数主流的视音频app，包括：youku、iqiyi、qq（音乐、视频）、网易、乐视、CNTV等等，数量太多，不全部列出了。
# 2018-1-11@DE

# 配置文件包括以下几个：
# /etc/storage/fic/start.sh  ，启动脚本 和 用于初始化流量伪装表。
# /etc/storage/fic/r.tocn.conf  这个文件复制到 /etc/storage/dnsmasq/dnsmasq.d/r.tocn.conf ，其中的 ipinfo.io 是用于检测地区的，你也可以在模块运行后浏览器访问 ipinfo.io 看看到底流量伪装是否成功。
# /etc//storage/fic/fic.sh  这个文件用于自动检测 ss 是否正常，自动切换ss 服务器。里面需要设置你自己的ss服务器参数，请保证各台ss-server 的端口、密码、加密方式的一致，我是个懒人，不想处理那么复杂的情况。

# ↓↓↓↓↓配置你自己的ss服务器参数↓↓↓↓↓
server1=xxxx1.dynu.com
server2=xxxx2.dynu.com
server3=xxxx3.dynu.com
ss_router_port=1234   #服务器端口
ss_passwd=password   #密码
method=chacha20       #加密方式




index=1
eval server="\$"server${index}
killall ss-redir
logger -t "FIC" "Connecting server: $server..."
ss-redir -s $server -p $ss_router_port -l 1008 -b 0.0.0.0 -k $ss_passwd -m $method -u -f /tmp/tocn_ss.pid
sleep 3

while true
do
	country=`wget -qO- https://api.ip.sb/geoip | sed 's/.*try_code":"\([A-Z]*\).*/\1/g'`
	if [ "$country" != "CN" ]; then
		logger -t "FIC" "ChinaServer incorrect: $country, try next server: $server."
		
		let index+=1
		eval server="\$"server${index}
		if [ -z "$server" ]; then 
			index=0
			logger -t "FIC:" "ChinaServer run over. Sleep 60sec."
			sleep 60
		else
			killall ss-redir
			sleep 2
			ss-redir -s $server -p $ss_router_port -l 1008 -b 0.0.0.0 -k $ss_passwd -m $method -u -f /tmp/tocn_ss.pid
			sleep 3
		fi
			
	else
		logger -t "FIC" "Country Check: $country, next checkpoint: 120sec."
		sleep 120 #等120秒继续监测地区代码
	fi

done