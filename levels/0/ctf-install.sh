#!/bin/bash
#
# Install the level.
#

set -o nounset
set -o errexit

if [ "${#}" -ne "1" ]; then
  echo "Usage: ${0} <password>"
  exit 1
fi

DIR="$( cd "$( dirname "$0" )" && pwd)"
PASSWORD="${1}"

cd "${DIR}"

# This is black magic, but prevents sqlite3 installation from failing due to
# node-gyp permission issues.
npm config set user 0
npm config set unsafe-perm true

# Install.
npm install --loglevel=info

# Remove the dummy database, and create a new one with the password.
rm -f "${DIR}/level00.db"
node "${DIR}/ctf-install.js" "${PASSWORD}"
