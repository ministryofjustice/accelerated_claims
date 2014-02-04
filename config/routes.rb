AcceleratedClaims::Application.routes.draw do
  root 'claim#new'
  get '/new', controller: :claim, action: :new
  post '/submission', controller: :claim, action: :submission
  get '/thank_you', controller: :claim, action: :thank_you
end
