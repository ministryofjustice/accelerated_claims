source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.8'

# Enable HAML (required for MOJ toolkit)
gem 'haml-rails'

# Use SCSS for stylesheets
gem 'sprockets', '~> 2.11.0'
gem 'sass-rails', '~> 4.0.3'

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
gem 'govuk_frontend_toolkit', '1.5.0'
# MOJ styles
gem 'moj_template', '0.16.0'
# required for feedback form
gem 'zendesk_api'
gem 'mail'

gem 'faraday'
gem 'redis-rails'

gem 'excon'

group :production, :development do
#  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'simplecov', require: false
  gem 'rspec-rails'
  gem 'rspec-legacy_formatters'
  gem 'jasmine-core', '~> 2.0.0'
  gem 'jasmine', '~> 2.0.2'
  gem 'jasmine-rails', '~> 0.9.1'
  gem 'jasmine-jquery-rails', '~> 2.0.2'
  gem 'guard-jasmine', git: 'https://github.com/guard/guard-jasmine', branch: 'jasmine-2'
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
  gem 'selenium-webdriver'
  gem 'curb'
  gem 'show_me_the_cookies'
  gem 'codeclimate-test-reporter', require: nil
  gem 'ruby-prof'
  gem 'w3c_validators'
end

gem 'pdf-forms', '0.5.5'
gem 'uk_postcode', '1.0.0'


# validate that submitted dates are actually dates
gem 'validates_timeliness', '~> 3.0'

# pretty logstashing
gem 'logstasher'

# statsd client
gem 'statsd-ruby'

gem 'courtfinder-client', '0.0.4'
