source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~>4.2.7'

# Enable HAML (required for MOJ toolkit)
gem 'haml-rails'

# Use SCSS for stylesheets
gem 'sprockets', '~> 3.7.0'
gem 'sprockets-rails', '~> 3.2.0'
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery + underscore as the JavaScript library
gem 'jquery-rails'
gem 'underscore-rails'
gem 'coffee-rails'

# production webserver
gem 'unicorn'

# Gov.uk styles
gem 'govuk_frontend_toolkit', '= 2.0.1'
gem 'govuk_elements_rails', '= 0.1.1'

# MOJ styles
gem 'moj_template'

# required for feedback form
gem 'zendesk_api'
gem 'mail'

gem 'faraday'
gem 'redis-rails'

gem 'excon'
gem 'logstuff'

gem 'nokogiri', '~> 1.7.2'
gem 'pkg-config'
gem 'safe_yaml', '~>1.0.4'

gem 'pdf-forms', '0.6.0'
gem 'uk_postcode'

# validate that submitted dates are actually dates
gem 'validates_timeliness'

# pretty logstashing
gem 'logstasher'

# statsd client
gem 'statsd-ruby'

gem 'courtfinder-client', '0.0.6'

group :production do
  gem 'sentry-raven'
end

group :development, :test do
  gem 'simplecov', require: false
  gem 'rspec-rails', '~>3.5'
  gem 'jasmine-core', '~> 2.2'
  gem 'jasmine'
  gem 'jasmine-rails', '~> 0.12.6'
  gem 'jasmine-jquery-rails', '~> 2.0.3'
  gem 'guard-jasmine'
  gem 'quiet_assets'
  gem 'byebug'
  gem 'dotenv-rails'  # set environment variables via the filesystem
  gem 'launchy'
  gem 'guard-coffeescript'
  gem 'awesome_print'
  gem 'timecop'
  gem 'pry'
  gem 'pry-stack_explorer'
  gem 'foreman'
  gem 'fuubar' # Rspec formatter with fast fail.
end

group :test do
  gem 'webmock'
  gem 'parallel'
  gem 'rspec_junit_formatter'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'brakeman'
  gem 'ci_reporter'
  gem 'poltergeist'
  gem 'phantomjs'
  gem 'selenium-webdriver'
  gem 'curb'
  gem 'show_me_the_cookies'
  gem 'codeclimate-test-reporter', require: nil
  gem 'ruby-prof'
  gem 'w3c_validators'
  gem 'capybara-screenshot'
  gem 'capybara-webkit', '~> 1.14'
end
