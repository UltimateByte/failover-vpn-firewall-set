# failover-vpn-firewall-set
Simple script to enable or disable iptables redirect rules for VPN through failover IP

# Usage

`wget https://raw.githubusercontent.com/UltimateByte/failover-vpn-firewall-set/master/firewall.sh`

`chmod +x firewall.sh`

`nano firewall.sh`

## Commands

`./firewall.sh enable`

`./firewall.sh disable`

## Sample output

````
root@webserver:/etc/openvpn# ./firewall.sh enable
Enable VPN rules
Allowing forwarding
Applying iptables:
 -> Redirect failover: x.x.x.x to client: 10.8.0.4 on network: 10.8.0.0/24
[OK] Job done
root@webserver:/etc/openvpn# ./firewall.sh disable
Disable VPN rules
Disallow forwarding
Removing iptables:
 <- Redirect failover: x.x.x.x to client: 10.8.0.4 on network: 10.8.0.0/24
[OK] Job done
````
