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

    get  '/cookies',        controller: :static, action: :cookies
    get  '/terms',          controller: :static, action: :terms

    get  '/heartbeat',      controller: :application, action: :heartbeat
    get  '/expire_session', controller: :application, action: :expire_session

    # zendesk
    resource :feedback,   only: [:new, :create], controller: 'feedback'
  end
end
