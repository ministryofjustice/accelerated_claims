AcceleratedClaims::Application.routes.draw do
  root 'claim#new'
  get '/new', controller: :claim, action: :new
  post '/submission', controller: :claim, action: :submission

  # routes to temporary front-end layout
  get '/pdf' => 'temp#pdf'
end
