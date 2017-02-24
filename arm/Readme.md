# Readme

## 更新
1. 修改了各个文件以适用于linksys1900ACV2路由器，其2.4gwifi设备为radio0,ifacename名称为wlan1,这两点与之前路由器不同，需注意。
2. 增加了findrouter.sh脚本的延时，增加了不正常退出的提示。
3. 修改了C程序，增加了SSID数组的大小，在周围含有中文热点时由于编码规则不同会导致溢出，出现segmentation fault。已解决
4. 解决了bug：当周围没有openwrt的AP时，会自动连接到信号最强的其他AP，因此修改了C文件中的bestrouter赋值方法，当周围没有openwrt的AP热点时，exit(1)不更换连接，保持上一次的client连接。
5. 优化了连接规则，只有当信号强度比当前连接信号强度多20dbm时才会改变连接。

## 进展
此程序可以放入/etc/rc.d/rc.local中开机运行

## 使用方法
直接运行总的shell脚本Wireless_self_organizing_link.sh即可，需保证所有shell脚本和C程序在路由器根目录/下。
程序运行过程中将会在/tmp目录下重复创建文件并读取文件。
也可以在/etc/rc.d/rc.local中添加一行：sh /Wireless_self_organizing_link.sh，开机自动运行。

## 使用限制
用于测试路由器，其ip地址只能为192.168.1.13,因为初始化脚本ap13.sh将会初始化路由器lan地址为192.168.1.13
只能用于arm架构的路由器。在此为linksys1900ACV2路由器。
chooserouter.c文件需要使用特定的编译器进行编译，linksys1900ACV2路由器需要使用arm-openwrt-linux-gcc进行编译。该编译工具需要对linksys1900ACV2路由器的openwrt系统源文件进行编译获得。

## BUG
运行总shell脚本时出现'radio0' is disabled 但是不影响使用。

