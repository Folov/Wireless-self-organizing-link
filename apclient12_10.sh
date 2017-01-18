#!/bin/ash
echo "apclient12_10"
uci set network.wwan=interface
uci set network.wwan._orig_ifname=wlan0
uci set network.wwan._orig_bridge=false
uci set network.wwan.proto=static
uci set network.wwan.ipaddr=192.168.1.12
uci set network.wwan.netmask=255.255.255.0
uci set network.wwan.gateway=192.168.1.10
uci set network.wwan.dns=202.205.16.4
uci commit network

uci set wireless.radio0.channel=6
uci set wireless.radio0.txpower=19
uci set wireless.radio0.country=US
uci set wireless.radio0.disabled=0

uci set wireless.@wifi-iface[0].device=radio0
uci set wireless.@wifi-iface[0].mode=sta
uci set wireless.@wifi-iface[0].ssid=dd-wrt
uci set wireless.@wifi-iface[0].encryption=none
uci set wireless.@wifi-iface[0].network=wwan
uci set wireless.@wifi-iface[0].bssid=00:1A:70:E6:1D:88
uci commit wireless

uci set firewall.@zone[0].forward=ACCEPT
uci set firewall.@zone[0].network="lan"
uci set firewall.@zone[1].forward=ACCEPT
uci set firewall.@zone[1].network="wan wwan"
uci commit firewall

uci add wireless wifi-iface
uci set wireless.@wifi-iface[1].device=radio0
uci set wireless.@wifi-iface[1].mode=ap
uci set wireless.@wifi-iface[1].ssid=openwrt12
uci set wireless.@wifi-iface[1].encryption=none
uci set wireless.@wifi-iface[1].network=lan
uci commit wireless

# wifi down
# sleep 1
# wifi
# sleep 1

uci delete dhcp.lan.leasetime
uci delete dhcp.lan.limit
uci delete dhcp.lan.start
uci set dhcp.lan.ignore=1
uci set dhcp.lan.ra_management=1
uci commit dhcp

uci set network.lan.ipaddr=192.168.1.12
uci commit network

/etc/init.d/dnsmasq restart
sleep 1
/etc/init.d/network restart


