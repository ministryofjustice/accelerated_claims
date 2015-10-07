# Be sure to restart your server when you modify this file.

if Rails.env.production?
  AcceleratedClaims::Application.config.session_store :redis_store,
      key: '_accelerated_claims_session',
      :servers =>{
        :host      => (ENV['REDIS_HOST']),
        :port      => 6379,
        :db        => 1
      },
      expires_in: 60.minutes
else
  AcceleratedClaims::Application.config.session_store :cache_store,
      key: '_accelerated_claims_session',
      expire_after: 60.minutes
end
