#!/bin/bash

echo 'running rails server'
bundle exec rails s -p 5555 &
rails_pid=$!

# Make sure the rails server is stopped when this script finishes
trap "kill $rails_pid" EXIT

sleep 10
echo 'running casper tests'
casperjs test ./spec/javascript/ --url='http://localhost:5555/' --no-colors --xunit=log.xml

