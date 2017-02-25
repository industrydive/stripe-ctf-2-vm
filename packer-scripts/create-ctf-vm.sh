#!/bin/bash
#
# Create the CTF VM.
#
# This script was created for use with OS X, but should hopefully work in other
# distributions.
#

# Unfortunately, RVM will fail if running with nounset. So we just have to be
# more diligent when writing the scripts.
# set -o nounset
set -o errexit

DIR="$( cd "$( dirname "$0" )" && pwd)"
PROJECT_DIR="${DIR}/.."

# Obtain the necessary configuration variables.
source "${PROJECT_DIR}/config/environment.sh"

DEF_NAME="stripe-ctf-2-ubuntu-14.04"
PACKER_DIR="${PROJECT_DIR}/packer"
PRIVATE_KEY_PATH="${PACKER_DIR}/id_rsa"
SSH_HOST_PORT="8222"

# ---------------------------------------------------------------------------
# Clean up known_hosts.
# ---------------------------------------------------------------------------

# When building multiple VMs we're going to have local known_hosts entries that
# will cause issues. Get rid of those.
KNOWN_HOSTS="${HOME}/.ssh/known_hosts"

if [[ -f "${KNOWN_HOSTS}" ]]; then
  if [[ "${OSTYPE}" =~ ^darwin[0-9]+$ ]]; then
    sed -i "" "/${IP_ADDRESS}/d" "${KNOWN_HOSTS}"
  else
    sed -i "/${IP_ADDRESS}/d" "${KNOWN_HOSTS}"
  fi
fi

# ---------------------------------------------------------------------------
# Assemble materials in the packer directory.
# ---------------------------------------------------------------------------

rm -Rf "${PACKER_DIR}"
cp -rf "${PROJECT_DIR}/packer-data" "${PACKER_DIR}"

# Add the zipped levels for upload to the VM, and arrange it so that only the
# "apps" part of the path is included in the zip file.
cd "${PROJECT_DIR}"
zip -q -r "${PACKER_DIR}/levels.zip" "levels"
cd -

# Copy in the configuration.
cp -f "${PROJECT_DIR}/config/environment.sh" "${PACKER_DIR}"

# Add a keypair.
ssh-keygen -t rsa -N "" -b 4096 -C "${ADMIN_USER}" -f "${PRIVATE_KEY_PATH}"

# ---------------------------------------------------------------------------
# Edit the template definition for the box.
# ---------------------------------------------------------------------------

# Set the main login user.

if [[ "${OSTYPE}" =~ ^darwin[0-9]+$ ]]; then
  sed -i "" \
    "s/ADMIN_USER_PASS/${ADMIN_USER_PASS}/" \
    "${PACKER_DIR}/template.json"
  sed -i "" \
    "s/ADMIN_USER/${ADMIN_USER}/" \
    "${PACKER_DIR}/template.json"
  sed -i "" \
    "s/SSH_HOST_PORT/${SSH_HOST_PORT}/" \
    "${PACKER_DIR}/template.json"
  sed -i "" \
    "s/ADMIN_USER_PASS/${ADMIN_USER_PASS}/" \
    "${PACKER_DIR}/preseed.cfg"
  sed -i "" \
    "s/ADMIN_USER/${ADMIN_USER}/" \
    "${PACKER_DIR}/preseed.cfg"
else
  sed -i \
    "s/ADMIN_USER_PASS/${ADMIN_USER_PASS}/" \
    "${PACKER_DIR}/template.json"
  sed -i \
    "s/ADMIN_USER/${ADMIN_USER}/" \
    "${PACKER_DIR}/template.json"
  sed -i \
    "s/SSH_HOST_PORT/${SSH_HOST_PORT}/" \
    "${PACKER_DIR}/template.json"
  sed -i \
    "s/ADMIN_USER_PASS/${ADMIN_USER_PASS}/" \
    "${PACKER_DIR}/preseed.cfg"
  sed -i \
    "s/ADMIN_USER/${ADMIN_USER}/" \
    "${PACKER_DIR}/preseed.cfg"
fi

# ---------------------------------------------------------------------------
# Build the new Virtualbox VM.
# ---------------------------------------------------------------------------

packer build \
  -force \
  "${PACKER_DIR}/template.json"

# ---------------------------------------------------------------------------
# Add networking for the hostonly network with defined IP.
# ---------------------------------------------------------------------------

# Set up networking by adding a hostonly network adaptor for ${IP_ADDRESS}
# and then adding a suitable network configuration inside the VM.
#
# IMPORTANT NOTE: when the box is exported, the network adaptor setting goes
# with it - but only the setting. When imported to a new host the actual network
# adaptor is not created, only the setting to use one is imported.
#
# Thus creating the network adaptor here is really only useful for development
# purposes.
#

# At this point the VM is shutdown.

# Has this already been set up for this VM? e.g. if we're testing.
if VBoxManage showvminfo "${DEF_NAME}" | grep -q "Attachment: Host-only Interface"; then
  echo "Host-only adaptor already assigned for this VM."
else
  echo "Assigning host-only adaptor for VM at ${IP_ADDRESS}, with gateway ${GATEWAY}..."

  INTERFACE=`VBoxManage hostonlyif create`
  ARR=()
  IFS="'" read -a ARR <<< "${INTERFACE}"
  INTERFACE="${ARR[1]}"

  VBoxManage hostonlyif ipconfig "${INTERFACE}" --ip "${GATEWAY}"

  VBoxManage modifyvm "${DEF_NAME}" --hostonlyadapter2 "${INTERFACE}"
  VBoxManage modifyvm "${DEF_NAME}" --nic2 hostonly

  # Restart.
  VBoxManage startvm "${DEF_NAME}" --type headless

  sleep 5
fi

# Log in and delete /EMPTY, which is the file created to fill up the
# disk. If it is allowed to remain, then the disk fills up very quickly and the
# VM stops working.
#
# TODO: there is an earlier attempt to delete /EMPTY in cleanup.sh, but it does
# not work. Why?
ssh \
  "${ADMIN_USER}@localhost" \
  -o StrictHostKeyChecking=no \
  -i "${PRIVATE_KEY_PATH}" \
  -p "${SSH_HOST_PORT}" \
  bash -c "'
echo "Removing /EMPTY..."
sudo rm -fv /EMPTY
'"

# Next log in and set up the network interface inside the VM, assuming it wasn't
# there before.
ssh \
  "${ADMIN_USER}@localhost" \
  -o StrictHostKeyChecking=no \
  -i "${PRIVATE_KEY_PATH}" \
  -p "${SSH_HOST_PORT}" \
  bash -c "'
# To match the hostonly adaptor that will be created for the VM.
# The token IP_ADDRESS will be replaced.
if ! sudo grep -q "${IP_ADDRESS}" /etc/network/interfaces; then
  echo "Setting up hostonly adaptor interface for ${IP_ADDRESS}..."

  cat > /tmp/interfaces <<EOF
# Hostonly adaptor.
auto eth1
iface eth1 inet static
  address ${IP_ADDRESS}
  netmask 255.255.255.0
EOF

  sudo -s bash -c \"cat /tmp/interfaces >> /etc/network/interfaces\"
  sudo ifconfig eth1 up
  echo "Hostonly adaptor interface for ${IP_ADDRESS} set up."
else
  echo "Hostonly adaptor interface for ${IP_ADDRESS} already set up."
fi
'"

# Wait 60 seconds. Shutting down too soon will lose this last change to the
# network interfaces for reasons that are obscure but probably relate to disk
# flushing behavior.
echo "Waiting for 60 seconds before shutdown..."
sleep 60

# Shutdown.
echo "Gracefully shutting down the VM..."
VBoxManage controlvm "${DEF_NAME}" acpipowerbutton
