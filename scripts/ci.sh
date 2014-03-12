#!/bin/bash

# Stop on first error
set -e

function msg {
    echo -e "\n\n\n -----------> ${1} <-----------"
}

if hash npm 2>/dev/null; then
  msg 'node installed'
  msg `npm -v`
  if [ -z `npm list | grep casperjs`]; then
    msg 'installing casper'
    echo `npm install -g casperjs`
  else
    msg 'casper installed'
  fi
else
  msg 'node not installed'
fi

msg "installing gems"
bundle install --deployment --without development --path vendor/bundler

msg "setting up CI & running the specs"
RAILS_ENV=test bundle exec rake ci:setup:rspec spec

msg "running brakeman"
bundle exec brakeman -z
