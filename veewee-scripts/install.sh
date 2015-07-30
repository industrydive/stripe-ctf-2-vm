#!/bin/bash
#
# Install Veewee, RVM, and dependencies.
#
# This script was created for use with OS X, but should hopefully work in other
# distributions. It assumes that the following tools are already in place:
#
# - git
# - brew (for OS X)
#

# Unfortunately, RVM will fail if running with nounset. So we just have to be
# more diligent when writing the scripts.
# set -o nounset
set -o errexit

DIR="$( cd "$( dirname "$0" )" && pwd)"

# --------------------------------------------------------------------------
# Sort out OS X dependencies.
# --------------------------------------------------------------------------

if [[ "${OSTYPE}" =~ "darwin" ]]; then
  brew install --overwrite homebrew/dupes/apple-gcc42
  brew install --overwrite gpg
fi

# --------------------------------------------------------------------------
# Install Ruby Version Manager (RVM).
# --------------------------------------------------------------------------

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby

# Put RVM into the path and ensure it is recognized for this user.
grep -q ".rvm/scripts/rvm" "${HOME}/.bash_profile" || \
cat >> "${HOME}/.bash_profile" <<EOF
# Set up for using RVM installed for this user.
[[ -s "\${HOME}/.rvm/scripts/rvm" ]] && source "\${HOME}/.rvm/scripts/rvm"
EOF
source "${HOME}/.bash_profile"

# --------------------------------------------------------------------------
# Install Veewee.
# --------------------------------------------------------------------------

VEEWEE_DIR="/${DIR}/../veewee"

# Download Veewee if needed.
if [[ ! -d "${VEEWEE_DIR}" ]]; then
  git clone https://github.com/jedi4ever/veewee.git "${VEEWEE_DIR}"
else
  cd "${VEEWEE_DIR}"
  git fetch origin
  git reset --hard origin/master
fi

# Run the setup.
cd "${VEEWEE_DIR}"
rvm use ruby@veewee --create
gem install bundler
bundle install
