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
UUID=`uuid -v4`

echo "${PASSWORD}" > "${DIR}/level02-password.txt"
echo "${UUID}" > "${DIR}/secret-combination.txt"
