#!/bin/bash
#
# Export and package up the VM.
#
# This script was created for use with OS X, but should hopefully work in other
# distributions.
#

set -o nounset
set -o errexit

DIR="$( cd "$( dirname "$0" )" && pwd)"
PROJECT_DIR="${DIR}/.."
DEF_NAME="stripe-ctf-2-ubuntu-14.04"
DIST_DIR="${PROJECT_DIR}/dist"
EXPORT_DIR="${DIST_DIR}/${DEF_NAME}"
ARCHIVE_FILE="${DIST_DIR}/${DEF_NAME}.tar.gz"

rm -Rf "${DIST_DIR}"
mkdir -p "${EXPORT_DIR}"

echo "Exporting..."

# Export all the stuff that needs exporting.
vboxmanage \
  export \
  "${DEF_NAME}" \
  --output "${EXPORT_DIR}/${DEF_NAME}.ovf"

echo "Archiving..."

# Wrap it up into a tar file.
tar \
  -cz \
  -f "${ARCHIVE_FILE}" \
  "${EXPORT_DIR}" \
  -C "${DIST_DIR}"

echo "Complete. VM exported to ${ARCHIVE_FILE}."
