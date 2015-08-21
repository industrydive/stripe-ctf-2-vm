#!/bin/bash
#
# Halt the level.
#

set -o nounset
set -o errexit

DIR="$( cd "$( dirname "$0" )" && pwd)"
PIDFILE="${DIR}/pidfile"

if [ -f "${PIDFILE}" ]; then
  rm -f "${PIDFILE}"
  # Not ideal, but expedient.
  killall python
  echo "Level is now halted."
else
  echo "Level is already halted."
fi
