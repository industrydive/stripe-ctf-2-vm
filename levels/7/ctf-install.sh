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
python ./initialize_db.py ${PASSWORD}
