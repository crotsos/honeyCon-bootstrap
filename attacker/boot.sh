#! /usr/bin/env bash

# Create bridge to perform forwarding
ip route add 192.168.0.0/24 via 10.10.0.100 dev eth0
ip route add 10.11.0.0/24 via 10.10.0.100 dev eth0

# Adding ARP entry for router
arp -s 10.10.0.100 00:00:0a:0a:00:64



# ba:2f:0b:70:f1:56, ba:2f:0b:70:f1:56