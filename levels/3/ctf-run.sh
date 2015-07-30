#!/bin/bash
#
# Run the level.
#

set -o nounset
set -o errexit

DIR="$( cd "$( dirname "$0" )" && pwd)"
PIDFILE="${DIR}/pidfile"

if [ -f "${PIDFILE}" ]; then
  echo "Level is already running."
else
  # This one has to have a cwd in the directory due to the way the code is
  # written.
  cd "${DIR}"
  python secretvault.py > "${DIR}/flask.log" 2>&1 &
  echo $! > "${DIR}/pidfile"
  echo "Level is now running."
fi
