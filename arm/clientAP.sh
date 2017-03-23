#!/bin/ash
echo "clientAP"
# This file is to client given AP by 'bestrouter.txt', modifying the wwan's
# ip and gateway and ssid, changing wireless iface's bssid.

count=1
# This while loop is to use a beautiful tool for read in a line from a file.
# The loop runs 2 times to read 2 lines from 'bestrouter.txt', each line is
# used for different functions.
cat /tmp/bestrouter.txt | while read line
do
	if [ $count -eq 1 ]
	then
	#use SSID decide gateway ip
		gateway_ip=`echo $line | sed 's/openwrt//'`

		uci set network.wwan.ipaddr=192.168.$gateway_ip.13
		uci set network.wwan.gateway=192.168.$gateway_ip.$gateway_ip
		uci commit network
		uci set wireless.@wifi-iface[0].ssid=$line
		uci commit wireless
	else
		uci set wireless.@wifi-iface[0].device=radio1
		uci set wireless.@wifi-iface[0].mode=sta
		uci set wireless.@wifi-iface[0].encryption=none
		uci set wireless.@wifi-iface[0].network=wwan
		uci set wireless.@wifi-iface[0].bssid=$line
		uci commit wireless
		
		echo "done"
		# need restart wifi!
		wifi down
		wifi

		break
	fi
	count=2
done
exit 0


