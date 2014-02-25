#!/bin/bash

# Stop on first error
set -e

bundle install --deployment --without development --path vendor/bundler
bundle exec gem install ci_reporter --no-ri --no-rdoc
bundle exec rake -f vendor/bundler/ruby/2.0.0/gems/ci_reporter-1.9.1/stub.rake ci:setup:rspec spec
bundle exec rake brakeman
