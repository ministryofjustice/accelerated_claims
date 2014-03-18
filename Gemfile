source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'

# Enable HAML (required for MOJ toolkit)
gem 'haml-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# production webserver
gem 'unicorn'

# Gov.uk styles
gem 'govuk_frontend_toolkit', '0.43.2'
# MOJ styles
gem 'moj_template', '0.10.0'

# required for feedback form
gem 'zendesk_api'
gem 'mail'


group :production do
  gem 'redis-rails'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'quiet_assets'
  gem 'byebug'
  gem 'dotenv-rails'  # set environment variables via the filesystem
  gem 'launchy'
end

group :test do
  # gem 'webmock'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'poltergeist'
  gem 'guard-rspec'
  gem 'brakeman'
  gem 'ci_reporter'
end

gem 'pdf-forms', '0.5.5'
gem 'uk_postcode', '1.0.0'


# validate that submitted dates are actually dates
gem 'validates_timeliness', '~> 3.0'
