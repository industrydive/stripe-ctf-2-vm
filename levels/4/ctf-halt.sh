#!/bin/bash
#
# Halt the level.
#

set -o nounset
set -o errexit

DIR="$( cd "$( dirname "$0" )" && pwd)"
PIDFILE="${DIR}/pidfile"
CASPER_PIDFILE="${DIR}/pidfile-casper"

if [ -f "${PIDFILE}" ]; then
  if PID=`cat "${CASPER_PIDFILE}"`; then
    rm -f "${CASPER_PIDFILE}"
    kill -9 ${PID} || true
  fi

  if PID=`cat "${PIDFILE}"`; then
    rm -f "${PIDFILE}"
    kill -9 ${PID} || true
  fi
  echo "Level is now halted."
else
  echo "Level is already halted."
fi
