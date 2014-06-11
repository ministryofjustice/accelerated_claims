#!/bin/bash

# Stop on first error
set -e

function msg {
    echo -e "\n\n\n -----------> ${1} <-----------"
}


msg "installing gems"
bundle install --deployment --without development --path vendor/bundler

msg "running jasmine specs"
RAILS_ENV=test bundle exec rake spec:javascript

msg "setting up CI & running the specs"
RAILS_ENV=test bundle exec rake ci:setup:rspec spec

msg "running brakeman"
export LANG=en_GB.UTF-8 # leave this for brakeman
bundle exec brakeman -z


