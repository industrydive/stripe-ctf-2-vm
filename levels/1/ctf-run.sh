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
  cd "${DIR}"
  php -S 0.0.0.0:8000 > "${DIR}/phpserver.log" 2>&1 &
  echo $! > "${DIR}/pidfile"
  echo "Level is now running."
fi
