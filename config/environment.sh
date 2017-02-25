#!/bin/bash
#
# This script contains configuration for generating and provisioning the CTF VM.
# Alter it as desired.
#
# This file will be sourced by the code that needs to use it.
#

# Administrative user and password.
#
# This user is intended for troubleshooting and development. It has unrestricted
# sudo powers.
ADMIN_USER="ubuntu"
# Change this password!
ADMIN_USER_PASS="ubuntu"

# The login user for a CTF contestant. A contestant uses this user to run the
# various scripts needed to unlock and run contest levels.
CTF_USER="ctf"
CTF_USER_PASS="ctf"

# The users for running levels 1 and 2, which must be kept in isolation to
# prevent a nefarious contestant from breaking open the whole instance via the
# exploits involved. This might be considered an alternative way of winning,
# but does defeat some of the point of the exercise.
CTF_RUN_1_USER="ctf-1"
CTF_RUN_2_USER="ctf-2"

# VM details.
#
# IP address and gateway address for the hostonly adaptor. It is best not to
# change these, as then the instructions to participants would have to account
# for that change when creating the adaptor for the VM instance.
IP_ADDRESS="192.168.57.2"
GATEWAY="192.168.57.1"
