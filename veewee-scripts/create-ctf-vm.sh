#!/bin/bash
#
# Use Veewee to create the CTF VM.
#

# RVM, being terrible, can't deal with nounset.
#set -o nounset
set -o errexit

DIR="$( cd "$( dirname "$0" )" && pwd)"
PROJECT_DIR="${DIR}/.."

# If the user installed veewee then directly ran this script, they won't have
# loaded the necessary profile script. So make sure that has happened.
if [ -f "${HOME}/.bash_profile" ]; then
  source "${HOME}/.bash_profile"
fi

# Obtain the necessary configuration variables.
source "${PROJECT_DIR}/config/environment.sh"

DEF_NAME="stripe-ctf-2-ubuntu-14.04"
DEF_PATH="${PROJECT_DIR}/veewee/definitions/${DEF_NAME}"
PRIVATE_KEY_PATH="${DEF_PATH}/id_rsa"

# ---------------------------------------------------------------------------
# Grab a template and create a definition, forcing overwrite.
# ---------------------------------------------------------------------------

cd "${PROJECT_DIR}/veewee"
mkdir -p "${PROJECT_DIR}/veewee/definitions"
rm -Rf "${DEF_PATH}"
cp -r "${PROJECT_DIR}/veewee-data/definition" "${DEF_PATH}"

# Add the zipped levels for upload to the VM, and arrange it so that only the
# "levels" part of the path is included in the zip file.
cd "${PROJECT_DIR}"
zip -q -r "${DEF_PATH}/levels.zip" "levels"
cd -

# Add the configuration.
cp -f "${PROJECT_DIR}/config/environment.sh" "${DEF_PATH}"

# Add the ctf-* scripts.
cp -f "${PROJECT_DIR}/veewee-data/ctf-scripts/"* "${DEF_PATH}"

# Add a keypair.
ssh-keygen -t rsa -N "" -b 4096 -C "${ADMIN_USER}" -f "${PRIVATE_KEY_PATH}"

# ---------------------------------------------------------------------------
# Edit the template definition for the box.
# ---------------------------------------------------------------------------

# Set the main login user.
sed -i "" \
  "s/:ssh_user.*/:ssh_user => '${ADMIN_USER}',/" \
  "${DEF_PATH}/definition.rb"
sed -i "" \
  "s/:ssh_password.*/:ssh_password => '${ADMIN_USER_PASS}',/" \
  "${DEF_PATH}/definition.rb"
sed -i "" \
  "s/:ssh_host_port.*/:ssh_host_port => '${SSH_HOST_PORT}',/" \
  "${DEF_PATH}/definition.rb"
sed -i "" \
  "s/ADMIN_USER_PASS/${ADMIN_USER_PASS}/" \
  "${DEF_PATH}/preseed.cfg"
sed -i "" \
  "s/ADMIN_USER/${ADMIN_USER}/" \
  "${DEF_PATH}/preseed.cfg"

# ---------------------------------------------------------------------------
# Build the new Virtualbox VM.
# ---------------------------------------------------------------------------

# Build the box.
#
# The commented --skip-to-postinstall is very useful when testing, as the full
# build takes forever.
bundle exec veewee vbox build "${DEF_NAME}" \
  --force \
  --nogui \
  --auto \
  --workdir="${PROJECT_DIR}/veewee" #--skip-to-postinstall

# ---------------------------------------------------------------------------
# Add networking for the hostonly network with defined IP.
# ---------------------------------------------------------------------------

# Set up networking.
#
# By default we don't get the networking we want out of this; it'll be set up
# for NAT only, and we want it on a hostonly network with a specific IP address.
#
# Has this already been set up for this VM? e.g. if we're testing.
if vboxmanage showvminfo "${DEF_NAME}" | grep -q "Attachment: Host-only Interface"; then
  echo "Host-only adaptor already assigned for this VM."
else
  echo "Assigning host-only adaptor for VM at ${IP_ADDRESS}, with gateway ${GATEWAY}..."

  # Shutdown.
  vboxmanage controlvm "${DEF_NAME}" poweroff soft

  INTERFACE=`vboxmanage hostonlyif create`
  ARR=()
  IFS="'" read -a ARR <<< "${INTERFACE}"
  INTERFACE="${ARR[1]}"

  vboxmanage hostonlyif ipconfig "${INTERFACE}" --ip "${GATEWAY}"

  vboxmanage modifyvm "${DEF_NAME}" --hostonlyadapter2 "${INTERFACE}"
  vboxmanage modifyvm "${DEF_NAME}" --nic2 hostonly

  # Restart.
  vboxmanage startvm "${DEF_NAME}" --type headless

  sleep 5
fi

# Now log in and get the interface set up inside the VM.
ssh \
  "${ADMIN_USER}@localhost" \
  -o StrictHostKeyChecking=no \
  -i "${PRIVATE_KEY_PATH}" \
  -p "${SSH_HOST_PORT}" \
  bash -c "'
# To match the hostonly adaptor that will be created for the VM.
# The token IP_ADDRESS will be replaced.
if ! sudo grep -q "${IP_ADDRESS}" /etc/network/interfaces; then
cat > /tmp/interfaces <<EOF

# Hostonly adaptor.
auto eth1
iface eth1 inet static
  address ${IP_ADDRESS}
  netmask 255.255.255.0
EOF

sudo -s bash -c \"cat /tmp/interfaces >> /etc/network/interfaces\"
sudo ifconfig eth1 up
fi
'"
