#!/bin/bash

# Script to run casperjs tests on CI server

# if hash npm 2>/dev/null; then
#   version=`npm -v`
#   echo "node installed: $version"

#   version=`casperjs --version`
#   echo "casperjs installed: $version"

#   if [ -z $version ]; then
#     echo >&2 "requires casperjs but it's not installed. Aborting. Try: npm install -g casperjs"; exit 1;
#   fi
# else
#   echo 'node not installed'
# fi

echo 'running rails server'
bundle exec rails s -p 5555 &
rails_pid=$!

# Make sure the rails server is stopped when this script finishes
trap "kill $rails_pid" EXIT

sleep 10
echo 'running casper tests'
casperjs test ./spec/javascript/ --url='http://localhost:5555/' --no-colors --xunit=log.xml

