require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "active_model"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module AcceleratedClaims
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    ActionDispatch::Response.default_headers = {
      'X-Frame-Options' => 'DENY',
      'X-Content-Type-Options' => 'nosniff',
      'X-XSS-Protection' => '1; mode=block'
    }

    # app title appears in the header bar
    config.app_title = 'Civil Claims'
    config.proposition_title = 'Property repossession'
    # phase governs text indicators and highlight colours
    # presumed values: alpha, beta, live
    config.phase = 'beta'
    # product type may also govern highlight colours
    # known values: information, service
    config.product_type = 'service'
    # Feedback URL (URL for feedback link in phase banner)
    # Use 'auto_add_path' for it to add a path link to the new_feedback route
    config.feedback_url = ''
    # Google Analytics ID (Tracking ID for the service)
    config.ga_id = ''

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.precompile += %w(
        moj-base.css
        claims-global.css
        claims-layout.css
        claims-components.css
        claims-mixins.css
        claims-global.css
        claims-layout.css
        claims-forms.css
        claims-intro.css
        claims-usernav.css
        claims-progressnav.css
        claims-breadcrumb.css
        claims-tables.css
    )

  end
end
