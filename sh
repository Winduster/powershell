#!/bin/bash

# 更新系统包列表
sudo apt update

# 安装L2TP所需的包
sudo apt install -y strongswan xl2tpd

# 创建IPSec (strongSwan) 配置文件
cat > /etc/ipsec.conf <<EOF
config setup
    charondebug="ike 1, knl 1, cfg 0, net 0, esp 0, dmn 0,  mgr 0"

conn %default
    keyexchange=ikev1
    authby=secret
    type=transport
    left=%defaultroute
    leftprotoport=17/1701
    right=%any
    rightprotoport=17/%any
    auto=add
EOF

# 设置IPSec预共享密钥
echo "请输入您的IPSec预共享密钥:"
read -r IPSecPSK
cat > /etc/ipsec.secrets <<EOF
: PSK "$IPSecPSK"
EOF

# 创建xl2tpd配置文件
cat > /etc/xl2tpd/xl2tpd.conf <<EOF
[global]
ipsec saref = yes

[lns default]
ip range = 192.168.1.100-192.168.1.200
local ip = 192.168.1.99
require chap = yes
refuse pap = yes
require authentication = yes
name = LinuxVPNserver
ppp debug = yes
pppoptfile = /etc/ppp/options.xl2tpd
length bit = yes
EOF

# 创建PPP配置文件
cat > /etc/ppp/options.xl2tpd <<EOF
require-mschap-v2
ms-dns 8.8.8.8
ms-dns 8.8.4.4
auth
mtu 1410
mru 1410
EOF

# 创建VPN用户
echo "请输入VPN用户名:"
read -r VPN_USER
echo "请输入VPN密码:"
read -r VPN_PASSWORD
cat > /etc/ppp/chap-secrets <<EOF
$VPN_USER * $VPN_PASSWORD *
EOF

# 重启IPSec和xl2tpd服务
sudo systemctl restart ipsec xl2tpd

# 开启IP转发
sudo sysctl -w net.ipv4.ip_forward=1

# 配置防火墙规则
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o ppp+ -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i ppp+ -o eth0 -j ACCEPT

# 保存防火墙规则
sudo sh -c "iptables-save > /etc/iptables.rules"

echo "L2TP VPN服务器安装完成。"
=====================================================
@echo off
setlocal

set VPN_NAME=MyPPTPVpn
set VPN_SERVER=vpn.example.com
set VPN_USERNAME=myusername
set VPN_PASSWORD=mypassword

echo 创建PPTP VPN连接...
rasphone -a "%VPN_NAME%" -d "%VPN_SERVER%" -t "vpn" -p "pptp" -u "%VPN_USERNAME%" -w "%VPN_PASSWORD%" -i

echo 连接到PPTP VPN...
rasdial "%VPN_NAME%" "%VPN_USERNAME%" "%VPN_PASSWORD%"

echo 连接成功。
endlocal
====================================================
$vpnName = "MyL2TPVpn"
$serverAddress = "vpn.example.com"
$vpnUsername = "myusername"
$vpnPassword = "mypassword"
$preSharedKey = "mypresharedkey"

Add-VpnConnection -Name $vpnName -ServerAddress $serverAddress -TunnelType L2tp -L2tpPsk $preSharedKey -AuthenticationMethod MsChapv2 -EncryptionLevel Optional -Force
rasdial $vpnName $vpnUsername $vpnPassword
=====================================================
@echo off
echo 正在连接PPTP VPN...
rasdial "您的PPTP VPN连接名称" "您的用户名" "您的密码"
echo 已连接到PPTP VPN.
pause
