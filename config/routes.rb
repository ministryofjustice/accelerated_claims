AcceleratedClaims::Application.routes.draw do
  root 'claim#new'
  get '/new', controller: :claim, action: :new
  post '/claim_submission', controller: :claim, action: :claim_submission
  get '/thank_you', controller: :claim, action: :thank_you
end
