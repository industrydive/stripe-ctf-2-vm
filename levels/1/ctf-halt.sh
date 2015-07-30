#!/bin/bash
#
# Halt the level.
#

set -o nounset
set -o errexit

DIR="$( cd "$( dirname "$0" )" && pwd)"
PIDFILE="${DIR}/pidfile"

if [ -f "${PIDFILE}" ]; then
  PID=`cat "${PIDFILE}"`
  rm -f "${PIDFILE}"
  kill -9 ${PID}
  echo "Level is now halted."
else
  echo "Level is already halted."
fi
