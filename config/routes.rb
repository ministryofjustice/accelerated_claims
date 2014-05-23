AcceleratedClaims::Application.routes.draw do

  scope AcceleratedClaims::Application.config.relative_url_root || '/' do
    root 'claim#new'

    get  '/',              controller: :claim, action: :new
    post '/submission',    controller: :claim, action: :submission
    get  '/confirmation',  controller: :claim, action: :confirmation
    get  '/download',      controller: :claim, action: :download

    get  '/cookies',       controller: :static, action: :cookies
    get  '/terms',         controller: :static, action: :terms

    # zendesk
    resource :feedback,   only: [:new, :create], controller: 'feedback'
  end
end
