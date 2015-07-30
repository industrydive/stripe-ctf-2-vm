#!/bin/bash
#
# Use Veewee to export the CTF VM.
#
# This script was created for use with OS X, but should hopefully work in other
# distributions.
#

# Unfortunately, RVM will fail if running with nounset. So we just have to be
# more diligent when writing the scripts.
# set -o nounset
set -o errexit

DIR="$( cd "$( dirname "$0" )" && pwd)"
PROJECT_DIR="${DIR}/.."
DEF_NAME="stripe-ctf-2-ubuntu-14.04"

# If the user installed dependencies and then directly runs this script in the
# same terminal, then he or she won't have loaded the necessary profile script.
# So ensure that the profile is loaded.
if [ -f "${HOME}/.bash_profile" ]; then
  source "${HOME}/.bash_profile"
fi

cd "${PROJECT_DIR}/veewee"
# This command exports a tar archive file to veewee/${DEF_NAME}.box.
bundle exec veewee vbox export "${DEF_NAME}"

# Move the file to make it clear that it is in fact a tar archive.
DIST_DIR="${PROJECT_DIR}/dist"
VM_SOURCE="${PROJECT_DIR}/veewee/${DEF_NAME}.box"
VM_DEST="${PROJECT_DIR}/dist/${DEF_NAME}.tar"

# Move the archive to the dist directory, overwriting any previous file.
mkdir -p "${DIST_DIR}"
rm -f "${VM_DEST}"
mv "${VM_SOURCE}" "${VM_DEST}"
