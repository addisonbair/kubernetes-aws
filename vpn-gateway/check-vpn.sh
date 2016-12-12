#!/bin/bash
#
# Description:         Basic script to monitor VPN tunnel
# PATH needs to be set as this script will run as a cron job
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin"


# Global variables
TEST_HOST="docker.domain.com"
STATUS_IF=$(ip addr show | grep "tun0" | awk -F: '{print $2}')
COUNT=3

# Check if VPN's interface exist in the current environment, otherwise start VPN
function check_interface(){

test -z "$STATUS_IF" && start_openconnect

}

# Start openconnect (Cisco SSL VPN)
function start_openconnect(){

/etc/init.d/vpn-tunnel stop && /etc/init.d/vpn-tunnel start

}

# Check if interface is in place, ping host defined in global variables and check for echo-reply
# Restart VPN's in case there is no response from ICMP packets
function check_vpn(){

if [ $STATUS_IF == "tun0" ]
        then
                count=$(ping -c ${COUNT} ${TEST_HOST} | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')
                test $count = 0 && start_openconnect
fi

}

check_interface
check_vpn
