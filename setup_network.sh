#!/bin/bash

nmcli device modify wlan0 connection.zone ""
nmcli device down wlan0
nmcli device up wlan0
firewall-cmd --zone=trusted --remove-interface=wlan0 --permanent
firewall-cmd --zone=public --add-interface=wlan0 --permanent

nmcli device modify eth0 connection.zone ""
nmcli device down eth0
nmcli device up eth0
firewall-cmd --zone=public --remove-interface=eth0 --permanent
firewall-cmd --zone=trusted --add-interface=eth0 --permanent

firewall-cmd --reload
firewall-cmd --list-all-zones
