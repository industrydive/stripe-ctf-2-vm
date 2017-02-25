#!/bin/bash
#
# Provisioning clean up. This has to run at the end of the provisioning process.
#

echo "filling disk with zeroes"
dd if=/dev/zero of=/EMPTY bs=1M
# TODO: why doesn't this file get deleted by this command, and is still present
# when later logging in to the instance? =
#
# At present we force a deletion in the later stages of the VM creation script
# by logging in to delete /EMPTY, but having it work properly here would be
# preferable.
rm -fv /EMPTY

echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

echo "cleaning up udev rules"
rm -Rf /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -Rf /dev/.udev/
rm -Rf /lib/udev/rules.d/75-persistent-net-generator.rules
