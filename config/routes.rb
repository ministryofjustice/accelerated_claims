AcceleratedClaims::Application.routes.draw do
  scope AcceleratedClaims::Application.config.relative_url_root || '/' do
    root 'claim#new'
    get '/new', controller: :claim, action: :new
    post '/submission', controller: :claim, action: :submission
    get '/confirmation', controller: :claim, action: :confirmation
    get '/download', controller: :claim, action: :download
  end
end
