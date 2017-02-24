#!/bin/ash
echo "clientAP"
count=1
cat /tmp/bestrouter.txt | while read line
do
	if [ $count -eq 1 ]
	then
	#use SSID decide gateway ip
		gateway_ip=`echo $line | sed 's/openwrt//'`

		uci set network.wwan.gateway=192.168.1.$gateway_ip
		uci commit network
		uci set wireless.@wifi-iface[0].ssid=$line
	else
		uci set wireless.@wifi-iface[0].device=radio0
		uci set wireless.@wifi-iface[0].mode=sta
		uci set wireless.@wifi-iface[0].encryption=none
		uci set wireless.@wifi-iface[0].network=wwan
		uci set wireless.@wifi-iface[0].bssid=$line
		uci commit wireless

		ifconfig wlan0 down
		wifi

		break
	fi
	count=2
done
exit 0


