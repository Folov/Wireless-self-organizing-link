# Readme

## 更新
1. 增加了findrouter.sh脚本的延时，增加了不正常退出的提示。
2. 修改了C程序，增加了SSID数组的大小，在周围含有中文热点时由于编码规则不同会导致溢出，出现segmentation fault。已解决
3. 解决了bug：当周围没有openwrt的AP时，会自动连接到信号最强的其他AP，因此修改了C文件中的bestrouter赋值方法，当周围没有openwrt的AP热点时，exit(1)不更换连接，保持上一次的client连接。
4. 优化了连接规则，只有当信号强度比当前连接信号强度多20dbm时才会改变连接。
5. 修改了ip规则，路由器能够ping通其连接的路由器以及更前面的路由器，规则如下：
	openwrt12 ----> openwrt13 ----> openwrt10 ----> Internet
LAN:  192.168.12.12   192.168.13.13   192.168.10.10
WWAN: 192.168.13.12   192.168.10.13   	   N/A
GW:   192.168.13.13   192.168.10.10	   N/A
openwrt12只能ping通openwrt13，openwrt10以及Internet，反向则不行。
6. ·new·增加了changerouter.c，修改了总shell，当建立新连接时（新AP大于原AP20dBm），首先断开原有连接和自己的AP，等待10s，然后连接新AP，连接完毕后ping源点S，检查连接是否正确。

## 进展
此程序可以放入/etc/rc.d/rc.local中开机运行
路由器之间可前向通信
实现了简单的自组链路算法

## 使用方法
直接运行总的shell脚本Wireless_self_organizing_link.sh即可，需保证所有shell脚本和C程序在路由器根目录/下。
程序运行过程中将会在/tmp目录下重复创建文件并读取文件。
也可以在/etc/rc.d/rc.local中添加一行：sh /Wireless_self_organizing_link.sh，开机自动运行。
按顺序布置：源点S、中继端、中继端。。。当某中继端距离上一端较远以致信号不佳时，在其中加入一台新的中继端设备即可自动建立链路。

## 使用限制
用于测试路由器，其ip地址只能为192.168.12.12,因为初始化脚本ap12.sh将会初始化路由器lan地址为192.168.12.12
只能用于mips架构的路由器。在此为老师的PCB。
chooserouter.c文件需要使用特定的编译器进行编译，需要使用mips-openwrt-linux-gcc进行编译。该编译工具需要对路由器的openwrt系统源文件进行编译获得。

## BUG
目前只能进行前向通信

