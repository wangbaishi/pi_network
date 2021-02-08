#iptables -t nat -N V2RAY 
#iptables -t nat -A V2RAY -d 192.168.0.0/16 -j RETURN 
#iptables -t nat -A V2RAY -p tcp -j RETURN -m mark --mark 0xff 
#iptables -t nat -A V2RAY -p tcp -j REDIRECT --to-ports 12345 
#iptables -t nat -A PREROUTING -p tcp -j V2RAY 
#iptables -t nat -A OUTPUT -p tcp -j V2RAY 

#ip rule add fwmark 1 table 100
#ip route add local 0.0.0.0/0 dev lo table 100
iptables -t mangle -D V2RAY_MASK -d 192.168.0.0/16 -j RETURN
iptables -t mangle -D V2RAY_MASK -p udp --dport 67 -j RETURN
iptables -t mangle -D V2RAY_MASK -p udp --dport 68 -j RETURN
iptables -t mangle -D V2RAY_MASK -p udp --dport 53 -j RETURN
iptables -t mangle -D V2RAY_MASK -p udp -j TPROXY --on-port 12345 --tproxy-mark 1
iptables -t mangle -D PREROUTING -p udp -j V2RAY_MASK
iptables -t mangle -X V2RAY_MASK

