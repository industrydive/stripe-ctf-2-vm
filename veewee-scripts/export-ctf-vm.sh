#!/bin/bash
#
# Use Veewee to export the CTF VM.
#

# RVM, being terrible, can't deal with nounset.
#set -o nounset
set -o errexit

DIR="$( cd "$( dirname "$0" )" && pwd)"
PROJECT_DIR="${DIR}/.."
DEF_NAME="stripe-ctf-2-ubuntu-14.04"

# If the user installed then directly went to export, they won't have loaded
# the necessary profile script. So make sure that has happened.
if [ -f "${HOME}/.bash_profile" ]; then
  source "${HOME}/.bash_profile"
fi

cd "${PROJECT_DIR}/veewee"
# This exports a tar archive file to veewee/${DEF_NAME}.box.
bundle exec veewee vbox export "${DEF_NAME}"

# Move the tar file to make it clear what it is.
DIST_DIR="${PROJECT_DIR}/dist"
VM_SOURCE="${PROJECT_DIR}/veewee/${DEF_NAME}.box"
VM_DEST="${PROJECT_DIR}/dist/${DEF_NAME}.tar"

mkdir -p "${DIST_DIR}"
rm -f "${VM_DEST}"
mv "${VM_SOURCE}" "${VM_DEST}"
