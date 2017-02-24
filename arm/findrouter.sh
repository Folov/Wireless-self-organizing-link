iw dev wlan1 scan >| /tmp/iwscan.txt
egrep -w '^	SSID|^	signal|^BSS' /tmp/iwscan.txt | sed 's/(on wlan1)//; s/	//; s/BSS //; s/signal: //; s/SSID: //; s/ dBm//; s/ -- associated//; s/^-//' >| /tmp/routerlist.txt
#grep signal routerlist.txt | sort -k 3 -t : | head -1 | cut -f 1 -d ':' | cat >| bestline.txt


