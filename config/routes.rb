AcceleratedClaims::Application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  if defined?(Jasmine::Jquery::Rails::Engine)
    JasmineFixtureServer = Proc.new do |env|
      Rack::Directory.new('spec/javascripts/fixtures').call(env)
    end
    mount JasmineFixtureServer => '/spec/javascripts/fixtures'
  end

  scope AcceleratedClaims::Application.config.relative_url_root || '/' do
    root 'claim#new'

    get  '/',               controller: :claim, action: :new
    post '/submission',     controller: :claim, action: :submission
    get  '/confirmation',   controller: :claim, action: :confirmation
    get  '/download',       controller: :claim, action: :download
    get  '/data',           controller: :claim, action: :data
    get  '/raise_exception',controller: :claim, action: :raise_exception

    get  '/help',           controller: :static, action: :help, as: :help
    get  '/maintenance',    controller: :static, action: :maintenance, as: :maintenance
    get  '/cookies',        controller: :static, action: :cookies, as: :cookies
    get  '/accessibility',  controller: :static, action: :accessibility, as: :accessibility
    get  '/terms',          controller: :static, action: :terms, as: :terms
    get  '/expired',        controller: :static, action: :expired, as: :expired

    get 'ping',             controller: :heartbeat, action: :ping, format: :json
    get 'healthcheck',      controller: :heartbeat, action: :healthcheck, format: :json
    
    post '/expire_session', controller: :application, action: :expire_session
    post '/invalid_access_token', controller: :application, action: :invalid_access_token, as: :invalid_access_token

    # postcode lookup proxy
    get '/postcode',        controller: :postcode_lookup_proxy, action: :show

    get '/court-address/:postcode',   controller: :courtfinder, action: :address, as: :court_address

    # zendesk
    resource :feedback,     only: [:new, :create], controller: 'feedback'
    get '/ask-for-technical-help', controller: :user_callback, action: :new, as: :technical_help
    post '/user_callback_request', controller: :user_callback, action: :create

    # Healthchecks
    get '/ping', controller: :health_check, action: :ping
    get '/healthcheck', controller: :health_check, action: :healthcheck
  end
end
