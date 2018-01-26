# 写入防火墙规则

logger -t "【fakeincn】" "防火墙规则恢复，开始返回国内规则"

ipset -! -N tocn iphash

iptables -t nat -D PREROUTING -p tcp -m set --match-set tocn dst -j REDIRECT --to-port 1008
iptables -t nat -D OUTPUT -p tcp -m set --match-set tocn dst -j REDIRECT --to-port 1008
iptables -t nat -A PREROUTING -p tcp -m set --match-set tocn dst -j REDIRECT --to-port 1008
iptables -t nat -A OUTPUT -p tcp -m set --match-set tocn dst -j REDIRECT --to-port 1008

while read line ; do ipset add tocn $line ;done <<-EOF
120.92.96.181
101.227.139.217
101.227.169.200
103.7.30.89
103.7.31.186
106.11.186.4
106.11.47.20
106.11.47.19
106.11.209.2
111.13.127.46
111.206.208.163
111.206.208.164
111.206.208.166
111.206.208.36
111.206.208.37
111.206.208.38
111.206.208.61
111.206.208.62
111.206.211.129
111.206.211.130
111.206.211.131
111.206.211.145
111.206.211.146
111.206.211.147
111.206.211.148
115.182.200.50
115.182.200.51
115.182.200.52
115.182.200.53
115.182.200.54
115.182.63.51
115.182.63.93
117.185.116.152
118.244.244.124
122.72.82.31
123.125.89.101
123.125.89.102
123.125.89.103
123.125.89.157
123.125.89.159
123.125.89.6
123.126.32.134
123.126.99.39
123.126.99.57
123.59.122.104
123.59.122.75                
123.59.122.76
123.59.122.77
14.152.77.22
14.152.77.25
14.152.77.26
14.152.77.32
14.18.245.250
140.207.69.99
163.177.90.61
180.153.225.136
182.16.230.98
182.254.11.174
182.254.116.117
182.254.34.151
182.254.4.234
183.192.192.139
183.232.119.198
183.232.126.23
183.232.229.21
183.232.229.22
183.232.229.25
183.232.229.32
203.205.151.23
210.129.145.150
211.151.157.15
211.151.158.155
211.151.50.10
220.181.153.113
220.181.154.137
220.181.185.150
220.249.243.70
223.167.82.139
36.110.222.105
36.110.222.119
36.110.222.146
36.110.222.156
59.37.96.220
61.135.196.99
103.7.30.79
EOF

logger -t "【fakeincn】" "国内IP规则设置完成"



ipset -! -N rtocn hash:net
ipset add rtocn 106.11.1.1/16

iptables -t nat -D PREROUTING -p tcp -m set --match-set rtocn dst -j REDIRECT --to-port 1008
iptables -t nat -D OUTPUT -p tcp -m set --match-set rtocn dst -j REDIRECT --to-port 1008
iptables -t nat -A PREROUTING -p tcp -m set --match-set rtocn dst -j REDIRECT --to-port 1008
iptables -t nat -A OUTPUT -p tcp -m set --match-set rtocn dst -j REDIRECT --to-port 1008
logger -t "【fakeincn】" "优酷IP规则设置完成"

cp -f r.tocn.conf /etc/storage/dnsmasq/dnsmasq.d/r.tocn.conf

restart_dhcpd

