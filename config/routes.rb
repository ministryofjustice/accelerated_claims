AcceleratedClaims::Application.routes.draw do
  root 'claim#new'
  get '/new', controller: :claim, action: :new
  post '/submission', controller: :claim, action: :submission
  get '/confirmation', controller: :claim, action: :confirmation
  get '/download', controller: :claim, action: :download

  # routes to temporary front-end layout
  get '/pdf' => 'temp#pdf'
  get '/form' => 'temp#form'
end
