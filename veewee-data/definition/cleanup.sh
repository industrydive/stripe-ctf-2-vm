#!/bin/bash
#
# Cleanup; copied from Veewee template. Has to run last.
#

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

echo "cleaning up udev rules"
rm -Rf /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -Rf /dev/.udev/
rm -Rf /lib/udev/rules.d/75-persistent-net-generator.rules
