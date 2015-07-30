#!/bin/bash
#
# Provisioning script for the Strip CTF VM.
#
# This will run as root.
#

set -o nounset
set -o errexit

# --------------------------------------------------------------------------
# Development settings.
# --------------------------------------------------------------------------

echo "---------------------------------------------------------------"
echo "Loading environment variables..."
echo "---------------------------------------------------------------"

# This has been uploaded during the before_postinstall Veewee step.
source /tmp/environment.sh

# --------------------------------------------------------------------------
# Add keys to the admin users.
# --------------------------------------------------------------------------

echo "---------------------------------------------------------------"
echo "Adding key to ${ADMIN_USER} user..."
echo "---------------------------------------------------------------"

# Add the key to the user.
SSH_DIR="/home/${ADMIN_USER}/.ssh"
if [ ! -d "${SSH_DIR}" ]; then
  mkdir -p "${SSH_DIR}"
  chmod 700 "${SSH_DIR}"
  chown "${ADMIN_USER}:${ADMIN_USER}" "${SSH_DIR}"
fi

cat /tmp/id_rsa.pub >> "${SSH_DIR}/authorized_keys"
chmod 600 "${SSH_DIR}/authorized_keys"
chown "${ADMIN_USER}:${ADMIN_USER}" "${SSH_DIR}/authorized_keys"

# --------------------------------------------------------------------------
# Update packages.
# --------------------------------------------------------------------------

echo "---------------------------------------------------------------"
echo "Updating package repos..."
echo "---------------------------------------------------------------"

# Get things up to date.
apt-get update
# Technically we should do this as well, but it time-consuming.
#apt-get upgrade -y

# --------------------------------------------------------------------------
# Install tools and requirements.
# --------------------------------------------------------------------------

echo "---------------------------------------------------------------"
echo "Installing tool packages..."
echo "---------------------------------------------------------------"

apt-get install -y \
  build-essential \
  curl \
  nmap \
  python-dev \
  sqlite3 \
  unzip \
  uuid \
  zip

# --------------------------------------------------------------------------
# Install Node.js from binaries using n.
# See: https://github.com/tj/n
# --------------------------------------------------------------------------

echo "---------------------------------------------------------------"
echo "Installing Node.js..."
echo "---------------------------------------------------------------"

N_VERSION=2.0.1
cd /tmp
# Clean out any leftovers from an earlier provisioning run.
rm -rf n-${N_VERSION}
rm -f ${N_VERSION}.tar.gz

# Obtain n and install it.
wget --no-verbose https://github.com/tj/n/archive/v${N_VERSION}.tar.gz
tar zxf v${N_VERSION}.tar.gz
cd n-${N_VERSION}
make install

# Install a suitable version.
n -q 0.10.28

# --------------------------------------------------------------------------
# Install necessary packages serving PHP.
# --------------------------------------------------------------------------

echo "---------------------------------------------------------------"
echo "Installing PHP command line..."
echo "---------------------------------------------------------------"

apt-get install -y php5-cli

# --------------------------------------------------------------------------
# Install Python and Flask.
# --------------------------------------------------------------------------

echo "---------------------------------------------------------------"
echo "Installing Python and Python tools..."
echo "---------------------------------------------------------------"

apt-get -y install python-setuptools python-pip
pip install flask flup

# --------------------------------------------------------------------------
# Create the CTF user.
# --------------------------------------------------------------------------

echo "---------------------------------------------------------------"
echo "Creating ${CTF_USER} user..."
echo "---------------------------------------------------------------"

if ! (id -u "${CTF_USER}" >/dev/null 2>&1) ; then
  useradd -m "${CTF_USER}" -s /bin/bash
fi
echo "${CTF_USER}:${CTF_USER_PASS}" | chpasswd

# --------------------------------------------------------------------------
# Sort out the ctf-* scripts, move them from where they were placed.
# --------------------------------------------------------------------------

echo "---------------------------------------------------------------"
echo "Set up ctf-* binaries and PATH..."
echo "---------------------------------------------------------------"

cp /tmp/ctf-* /usr/local/bin
chown root:root /usr/local/bin/ctf-*
chmod a+x /usr/local/bin/ctf-*

# Amend the path to include the location for the ctf-* scripts.
cat > /etc/profile.d/ctf <<EOF
export PATH="${PATH}:/usr/local/bin"
EOF

# --------------------------------------------------------------------------
# Sudoers.
# --------------------------------------------------------------------------

echo "---------------------------------------------------------------"
echo "Set up sudo permissions."
echo "---------------------------------------------------------------"

# Let the ctf user use sudo for the ctf scripts.
# Let the admin user have passwordless sudo.
cat > /etc/sudoers.d/ctf <<EOF
${CTF_USER} ALL=(ALL) NOPASSWD: /usr/local/bin/ctf-root, /usr/local/bin/ctf-run, /usr/local/bin/ctf-halt
${ADMIN_USER} ALL=(ALL) NOPASSWD: ALL
EOF

# --------------------------------------------------------------------------
# Set up the levels; each level has the next level's password.
# --------------------------------------------------------------------------

echo "---------------------------------------------------------------"
echo "Setting up CTF level code with passwords..."
echo "---------------------------------------------------------------"

# Unzip the code.
rm -Rf "${CTF_DIR}"
mkdir -p "${CTF_DIR}"
unzip -o -q /tmp/levels.zip -d "${CTF_DIR}"

LEVELS_DIR="${CTF_DIR}/levels"

# Write passwords and set up levels. Levels are 0-8, each level is set up to
# contain the password of the level above. Level 8 is the end, but contains a
# password for winning.
PASSWORDS=( "" "" "" "" "" "" "" "" "" )
for LEVEL in {1..9}; do
  # Useful for testing
  # ${PASSWORDS[${LEVEL}]}="test-${LEVEL}"
  PASSWORDS[${LEVEL}]=$(uuid)
  echo "Level ${LEVEL}: ${PASSWORDS[${LEVEL}]}" >> "${CTF_DIR}/passwords.txt"
  echo "${PASSWORDS[${LEVEL}]}" > "${LEVELS_DIR}/${LEVEL}.pwd"

  # Put the password for level X into level X - 1.
  INIT_LEVEL=$((${LEVEL} - 1))
  "${LEVELS_DIR}/${INIT_LEVEL}/ctf-install.sh" "${PASSWORDS[${LEVEL}]}"
done

# Level 0 is unlocked already.
touch "${LEVELS_DIR}/0.unlocked"

# --------------------------------------------------------------------------
# Set up permissioning and restrictions.
# --------------------------------------------------------------------------

echo "---------------------------------------------------------------"
echo "Setting file permissions..."
echo "---------------------------------------------------------------"

# We want to exclude the ctf user from looking at this stuff, while allowing
# other users to do so.
chmod -R o-rwx "${CTF_DIR}"

# --------------------------------------------------------------------------
# Clean up things we don't want the ctf user to be able to see.
# --------------------------------------------------------------------------

echo "---------------------------------------------------------------"
echo "Cleaning up /tmp files..."
echo "---------------------------------------------------------------"

rm -f /tmp/environment.sh
rm -f /tmp/levels.zip
rm -f /tmp/ctf-*
