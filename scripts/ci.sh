#!/bin/bash

# Stop on first error
set -e

function msg {
    echo -e "\n\n\n -----------> ${1} <-----------"
}

msg "installing gems"
bundle install --deployment --without development --path vendor/bundler

msg "setting up CI & running the specs"
RAILS_ENV=test bundle exec rake ci:setup:rspec spec

# msg "running brakeman"
# bundle exec brakeman -z
