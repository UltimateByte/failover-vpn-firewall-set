#!/bin/bash
# This script is intended to route traffic from a VPN through a failover IP

# Settings

# Your failover IP
failover="x.x.x.x"
# The VPN network
vpnnetwork="10.8.0.0/24"
# The VPN client IP to redirect traffic to
vpnclient="10.8.0.6"

# Script

if [ -z "$1" ]; then
        echo "Info! Please specify enable or disable"
        exit
fi
if [ "$1" != "enable" ]&&[ "${1}" != "disable" ];then
        echo "Info! Please specify enable or disable"
        exit
fi

# Enable rule
if [ "$1" == "enable" ];then
        echo "Enable VPN rules"
        # Optional for dynamic failover
        #ifconfig eth0:0 178.32.107.110 netmask 255.255.255.255 broadcast 178.32.107.110

        # Allow forward
        echo "Allowing forwarding"
        echo 1 > /proc/sys/net/ipv4/ip_forward

        # Apply table
        echo "Applying iptables:"
        echo " -> Redirect failover: ${failover} to client: ${vpnclient} on network: ${vpnnetwork}"
        iptables -t nat -A POSTROUTING -s "${vpnnetwork}" ! -d "${vpnnetwork}" -j SNAT --to-source "${failover}"
        iptables -t nat -A PREROUTING -d "${failover}" -j DNAT --to-destination "${vpnclient}"
        echo "[OK] Job done"
        exit
fi

# Disable rules

if [ "$1" == "disable" ];then
        echo "Disable VPN rules"
        # Disallow forward
        echo "Disallow forwarding"
        echo 0 > /proc/sys/net/ipv4/ip_forward

        # Remove table
        echo "Removing iptables:"
        echo " <- Redirect failover: ${failover} to client: ${vpnclient} on network: ${vpnnetwork}"
        iptables -t nat -D POSTROUTING -s "${vpnnetwork}" ! -d "${vpnnetwork}" -j SNAT --to-source "${failover}"
        iptables -t nat -D PREROUTING -d "${failover}" -j DNAT --to-destination "${vpnclient}"

        # Optional for dynamic failover
        #ifconfig eth0:0 down
        echo "[OK] Job done"
        exit
fi
