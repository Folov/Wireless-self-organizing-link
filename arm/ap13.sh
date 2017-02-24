#!/bin/ash
echo "ap13"
# build ap
uci set wireless.radio1.channel=6
uci set wireless.radio1.txpower=19
uci set wireless.radio1.country=US
uci set wireless.radio1.disabled=0

uci add wireless wifi-iface
uci set wireless.@wifi-iface[1].device=radio1
uci set wireless.@wifi-iface[1].mode=ap
uci set wireless.@wifi-iface[1].ssid=openwrt13
uci set wireless.@wifi-iface[1].encryption=none
uci set wireless.@wifi-iface[1].network=lan
uci commit wireless

# build wwan & change lan
uci set network.wwan=interface
uci set network.wwan._orig_ifname=wlan1
uci set network.wwan._orig_bridge=false
uci set network.wwan.proto=static
uci set network.wwan.ipaddr=192.168.1.13
uci set network.wwan.netmask=255.255.255.0
uci set network.wwan.dns=202.205.16.4

uci set network.lan.ipaddr=192.168.1.13
uci commit network

# change firewall
uci set firewall.@zone[0].forward=ACCEPT
uci set firewall.@zone[0].network="lan"
uci set firewall.@zone[1].forward=ACCEPT
uci set firewall.@zone[1].network="wan wwan"
uci commit firewall

# change lan_dhcp
uci delete dhcp.lan.leasetime
uci delete dhcp.lan.limit
uci delete dhcp.lan.start
uci set dhcp.lan.ignore=1
uci set dhcp.lan.ra_management=1
uci commit dhcp

# restart
/etc/init.d/dnsmasq restart
sleep 1
/etc/init.d/network restart
