# This file is used to find all APs arround router, if iw dev xxx scan go wrong,
# it will return 1 and into the loop, rescan AP until it works well.
while [ 1 ]; do
	if iw dev wlan0 scan >| /tmp/iwscan.txt 
	then
		egrep -w '^	SSID|^	signal|^BSS' /tmp/iwscan.txt | sed 's/(on wlan0)//; s/	//; s/BSS //; s/signal: //; s/SSID: //; s/ dBm//; s/ -- associated//; s/^-//' >| /tmp/routerlist.txt
		exit 0
	fi
	sleep 1
done
