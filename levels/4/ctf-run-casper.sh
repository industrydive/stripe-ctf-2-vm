#!/bin/bash
#
# Run CasperJS in a loop every ~30 second or so to provide activity on the
# karma_fountain account.
#

set -o nounset
# Accept errors; we want to loop regardless of whether or not any one iteration
# errors out. Since we're using PhantomJS this is a possibility.
# set -o errexit

DIR="$( cd "$( dirname "$0" )" && pwd)"

while true; do
  casperjs "${DIR}/browser.coffee" http://localhost:4567
  sleep 30
done
