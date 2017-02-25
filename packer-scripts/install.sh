#!/bin/bash
#
# Download and install Packer at a suitably recent version.
#
# Written for OS X, but adaptable to other Unixes.
#

set -o nounset
set -o errexit

rm -f /tmp/packer.zip /tmp/packer

curl \
  -Ss \
  "https://releases.hashicorp.com/packer/0.12.2/packer_0.12.2_darwin_amd64.zip" \
  -o /tmp/packer.zip

unzip -o /tmp/packer.zip -d /tmp
cp -f /tmp/packer /usr/local/bin
