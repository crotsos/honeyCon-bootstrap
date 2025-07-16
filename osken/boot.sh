#! /usr/bin/env bash

# Create bridge to perform forwarding
ovs-vsctl --if-exists del-br br0
ovs-vsctl add-br br0 

# Clear IP addresses on interfaces
ifconfig eth0 0.0.0.0 up 
ifconfig eth1 0.0.0.0 up 

# Setup the configured IUP on the bridge interface
ifconfig br0 10.10.0.100/24 up 
ip addr add 10.11.0.100/24 dev br0

# Add interfaces to the bridge
ovs-vsctl add-port br0 eth0
ovs-vsctl add-port br0 eth1

ovs-ofctl add-flow br0 in_port=1,ip,nw_dst=192.168.0.10,actions=mod_dl_src:00:00:0a:0b:00:64,mod_dl_dst:56:84:5D:5A:9B:F1,mod_nw_src:10.11.0.100,mod_nw_dst:10.11.0.2,output:2
ovs-ofctl add-flow br0 in_port=2,ip,nw_src=10.11.0.2,actions=mod_dl_src:00:00:0a:0a:00:64,mod_dl_dst:ba:2f:0b:70:f1:56,mod_nw_dst:10.10.0.2,mod_nw_src:192.168.0.10,output:1