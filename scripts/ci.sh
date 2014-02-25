#!/bin/bash

# Stop on first error
set -e

bundle install --deployment --without development --path vendor/bundler
bundle exec rake ci:setup:rspec spec
bundle exec brakeman -z
