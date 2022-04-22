#!/bin/bash

ip route del  default dev tun0
ip route add  10.0.0.0/8 dev tun0
ip route add  172.20.0.0/16 dev tun0
ip route add  24.232.0.0/16 dev tun0
ip route add  192.168.185.0/24 dev tun0
ip route add  192.168.5.0/24 dev tun0
ip route add 200.61.204.6 dev tun0
ip route add 181.30.128.27 dev tun0
echo 'nameserver 24.232.0.33' > /etc/resolv.conf
echo 'nameserver 24.232.0.34' >> /etc/resolv.conf
