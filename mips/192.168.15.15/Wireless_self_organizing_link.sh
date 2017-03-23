#!/bin/ash
echo "Main Shell"
#Enable shell files
chmod +x /*.sh
chmod +x /chooserouter
#Init
/ap15.sh

flag=1
while [[ $flag -eq 1 ]]; do
	#Find Router(The result files are in /tmp)
	/findrouter.sh
	sleep 1
	#Choose Router
		/chooserouter /tmp/routerlist.txt
	if [[ $? -eq 0 ]]; then		#need update
		ping 192.168.10.10 -c 3
		if [[ $? -eq 0 ]]; then
			ifconfig wlan0-1 down
			sleep 9
			wifi
			sleep 1
		fi
		/chooserouter /tmp/routerlist.txt >| /tmp/bestrouter.txt
		sleep 1
		#Join AP, this will take a long time.
		/clientAP.sh
		sleep 15
		/changerouter /tmp/routerlist.txt
		if [[ $? -eq 1 ]]; then
			sleep 2
			/clientAP.sh
		fi
		sleep 2
	elif [[ $? -eq 1 ]]; then
		#statements
		echo "No need update"
	elif [[ $? -eq 2 ]]; then
		echo "routerlist.txt not exist or empty"
	elif [[ $? -eq 3 ]]; then
		echo "can't open file"
	fi
	sleep 2
done

exit 0

