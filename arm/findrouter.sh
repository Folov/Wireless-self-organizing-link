while [ 1 ]; do
	if iw dev wlan1 scan >| /tmp/iwscan.txt 
	then
		egrep -w '^	SSID|^	signal|^BSS' /tmp/iwscan.txt | sed 's/(on wlan1)//; s/	//; s/BSS //; s/signal: //; s/SSID: //; s/ dBm//; s/ -- associated//; s/^-//' >| /tmp/routerlist.txt
		exit 0
	fi
	sleep 1
done
