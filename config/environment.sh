#!/bin/bash
#
# Set configuration for generating and provisioning the CTF VM.
#
# This file will be sourced by the code the needs to use it.
#

# Administrative user and password.
#
# This is not the user for someone competing in the CTF. It is intended for
# troubleshooting and development. It has sudo powers.
ADMIN_USER="ubuntu"
# Change this password!
ADMIN_USER_PASS="ubuntu"

# The login user for a CTF contestant.
CTF_USER="ctf"
CTF_USER_PASS="ctf"

# Where are we putting the CTF contents in the VM?
CTF_DIR="/var/ctf"

# VM details.
#
# IP address and gateway address for the hostonly adaptor.
IP_ADDRESS="192.168.57.2"
GATEWAY="192.168.57.1"

SSH_HOST_PORT="7222"
