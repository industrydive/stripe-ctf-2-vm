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
  php -t "${DIR}" -S 0.0.0.0:7000 "${DIR}/routing.php" > "${DIR}/phpserver.log" 2>&1 &
  echo $! > "${DIR}/pidfile"
  echo "Level is now running."
fi
