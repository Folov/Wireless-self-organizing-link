#!/bin/ash
echo "client11"
uci set network.wwan.gateway=192.168.1.11
uci commit network

uci set wireless.@wifi-iface[0].device=radio0
uci set wireless.@wifi-iface[0].mode=sta
uci set wireless.@wifi-iface[0].ssid=openwrt11
uci set wireless.@wifi-iface[0].encryption=none
uci set wireless.@wifi-iface[0].network=wwan
uci set wireless.@wifi-iface[0].bssid=EE:88:8F:12:34:56
uci commit wireless

wifi down
sleep 1
wifi
