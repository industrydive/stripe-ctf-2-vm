#!/bin/bash
#
# Setup to use Veewee in either Linux or OS X.
#

# RVM, being terrible, can't deal with nounset.
#set -o nounset
set -o errexit

DIR="$( cd "$( dirname "$0" )" && pwd)"

if ! [[ "${OSTYPE}" =~ "darwin" ]]; then
  echo "Only OS X is supported."
  exit 1
fi

# --------------------------------------------------------------------------
# Get the dependencies sorted out.
# --------------------------------------------------------------------------

brew install --overwrite homebrew/dupes/apple-gcc42
brew install --overwrite gpg

# --------------------------------------------------------------------------
# Install Ruby Version Manager (RVM).
# --------------------------------------------------------------------------

# RVM installation process remains entirely substandard and disgusting.
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby

# Get RVN into the path and recognized for this user.
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
fi

# Run the setup.
cd "${VEEWEE_DIR}"
rvm use ruby@veewee --create
gem install bundler
bundle install
