#!/bin/ash
echo "Main Shell"
#Enable shell files
chmod +x /*.sh
#Init
/ap12.sh

flag=1
while [[ $flag -eq 1 ]]; do
	#Find Router(The result files are in /tmp)_3s
	/findrouter.sh
	sleep 3
	#Choose Router_1s
		/chooserouter /tmp/routerlist.txt
	if [[ $? -eq 0 ]]; then		#normal exit
		/chooserouter /tmp/routerlist.txt >| /tmp/bestrouter.txt
		sleep 1
		#Join AP_2s
		/clientAP.sh
		sleep 1
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

