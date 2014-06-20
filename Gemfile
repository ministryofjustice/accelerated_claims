source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.5'

# Enable HAML (required for MOJ toolkit)
gem 'haml-rails'

# Use SCSS for stylesheets
gem 'sprockets', '~> 2.11.0'
gem 'sass-rails', '~> 4.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

gem 'timecop'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery + underscore as the JavaScript library
gem 'jquery-rails'
gem 'underscore-rails'
gem 'coffee-rails'

# production webserver
gem 'unicorn'

# Gov.uk styles
gem 'govuk_frontend_toolkit', '0.43.2'
# MOJ styles
gem 'moj_template', '0.11.1'

# required for feedback form
gem 'zendesk_api'
gem 'mail'

gem 'faraday'

group :production do
  gem 'redis-rails'
  gem 'appsignal'
end

group :production, :development do
#  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'rspec-core', '2.99.0'
  gem 'rspec-rails', '2.99.0'
  gem 'rspec-mocks', '2.99.0'
  gem 'rspec-its'
  gem 'jasmine', '~> 1.3.2'
  gem 'jasmine-rails'
  gem 'jasmine-jquery-rails', '~> 1.5.9'
  gem 'guard-jasmine'
  gem 'quiet_assets'
  gem 'byebug'
  gem 'dotenv-rails'  # set environment variables via the filesystem
  gem 'launchy'
  gem 'guard-coffeescript'
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
end

gem 'pdf-forms', '0.5.5'
gem 'uk_postcode', '1.0.0'


# validate that submitted dates are actually dates
gem 'validates_timeliness', '~> 3.0'
