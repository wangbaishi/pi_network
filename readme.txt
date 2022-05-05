1. Setup v2ray. 

	Download v2ray_cli, may need to add "==" after subscribtion url. 

	https://github.com/Libunko/v2ray_cli 

 
 2.  Install packages and setup dhcpc 

	apt-get install hostapd 

	systemctl unmask hostapd 

	systemctl enable hostapd 

	apt install dnsmasq 

 

	vi /etc/dhcpcd.conf 

	Add the following lines: 

	interface wlan0 

	static ip_address=192.168.2.10/24 

	nohook wpa_supplicant 

 

3. Setup dhcp server 

	mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig 

	Add the following lines to dnsmasq.conf 

	interface=wlan0 

	dhcp-range=192.168.2.20,192.168.2.50,255.255.255.0,24h 

	domain=wlan 

 

4. Setup hostapd  

	vi /etc/hostapd/hostapd.conf 

	Add the following lines: 

	country_code=CN 

	interface=wlan0 

	ssid=dumbbell_raiser 

	hw_mode=g 

	channel=7 

	macaddr_acl=0 

	auth_algs=1 

	ignore_broadcast_ssid=0 

	wpa=2 

	wpa_passphrase=letsdodumbbell101 

	wpa_key_mgmt=WPA-PSK 

	wpa_pairwise=TKIP 

	rsn_pairwise=CCMP 

 
5. setup iptables 

	iptables -t nat -N V2RAY 

	iptables -t nat -A V2RAY -d 192.168.0.0/16 -j RETURN 

	iptables -t nat -A V2RAY -p tcp -j RETURN -m mark --mark 0xff 

	iptables -t nat -A V2RAY -p tcp -j REDIRECT --to-ports 12345 

	iptables -t nat -A PREROUTING -p tcp -j V2RAY 

	iptables -t nat -A OUTPUT -p tcp -j V2RAY 

  

	ip rule add fwmark 1 table 100 

	ip route add local 0.0.0.0/0 dev lo table 100 

	iptables -t mangle -N V2RAY_MASK 

	iptables -t mangle -A V2RAY_MASK -d 192.168.2.10 -j RETURN 

	iptables -t mangle -A V2RAY_MASK -p udp --dport 67 -j RETURN 

	iptables -t mangle -A V2RAY_MASK -p udp --dport 68 -j RETURN 

	iptables -t mangle -A V2RAY_MASK -p udp --dport 53 -j RETURN 

	iptables -t mangle -A V2RAY_MASK -p udp --sport 53 -j RETURN 

	iptables -t mangle -A V2RAY_MASK -p udp -j TPROXY --on-port 12345 --tproxy-mark 1 

	iptables -t mangle -A PREROUTING -p udp -j V2RAY_MASK 

 

6. setup v2ray configuration files: 

	https://guide.v2fly.org/app/transparent_proxy.html 
