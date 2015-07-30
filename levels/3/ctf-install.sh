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

# These two are just color, no meaning.
PROOF=`uuid -v4`
PLANS=`uuid -v4`

# Set up the the setup code; this should do the right thing as soon as the
# server code runs.
sed -i \
  "s/'dummy-password', 'dummy-proof', 'dummy-plans'/'${PASSWORD}', '${PROOF}', '${PLANS}'/" \
  "${DIR}/secretvault.py"
