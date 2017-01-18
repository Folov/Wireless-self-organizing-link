#!/bin/ash
echo "client10"
uci set network.wwan.gateway=192.168.1.10
uci commit network

uci set wireless.@wifi-iface[0].device=radio0
uci set wireless.@wifi-iface[0].mode=sta
uci set wireless.@wifi-iface[0].ssid=dd-wrt
uci set wireless.@wifi-iface[0].encryption=none
uci set wireless.@wifi-iface[0].network=wwan
uci set wireless.@wifi-iface[0].bssid=00:1A:70:E6:1D:88
uci commit wireless

wifi down
sleep 1
wifi
