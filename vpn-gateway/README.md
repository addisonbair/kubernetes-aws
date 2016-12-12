Place `vpn-tunnel` in `/etc/init.d`

Place `check-vpn.sh` in `/etc/usr/local/bin.sh`

Run `crontab -e`
Add: `* * * * * /usr/local/bin/check-vpn.sh`
Verify with: `crontab -l`

VPN Tunnel should survive reboots.

Run under autoscaling group with internal load balancer for maximum resillience
