#!/bin/bash

$some_port = 5555
echo 'running rails server'
bundle exec rails s -p $some_port &
rails_pid=$!

# Make sure the rails server is stopped when this script finishes
trap "kill $rails_pid" EXIT

sleep 10
echo 'running casper tests'
casperjs test ./spec/javascript/ --url='http://localhost:5555/' --no-colors --xunit=log.xml

