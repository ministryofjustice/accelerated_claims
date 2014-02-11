source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

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
gem 'govuk_template', '0.3.8'
gem 'govuk_frontend_toolkit', github: 'ministryofjustice/govuk_frontend_toolkit_gem', branch: 'asset-submodule'
# MOJ styles
gem 'moj_boilerplate', github: 'ministryofjustice/moj_boilerplate', tag: 'v0.6.2'

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'quiet_assets'
  gem 'byebug'
  gem 'dotenv-rails'  # set environment variables via the filesystem
end

gem 'pdf-forms', '0.5.5'
