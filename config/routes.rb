AcceleratedClaims::Application.routes.draw do
  
  scope AcceleratedClaims::Application.config.relative_url_root || '/' do
    root 'claim#landing'

    get  '/',              controller: :claim, action: :landing
    get  '/new',           controller: :claim, action: :new
    post '/submission',    controller: :claim, action: :submission
    get  '/confirmation',  controller: :claim, action: :confirmation
    get  '/download',      controller: :claim, action: :download

    # zendesk
    resource :feedback,   only: [:new, :create], controller: 'feedback' 
  end
end
