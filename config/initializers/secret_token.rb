# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

if ENV['SECRET_KEY_BASE'].nil? && (Rails.env.test? || Rails.env.development?)
  ENV['SECRET_KEY_BASE'] = '2aa28b3896def6947d887ad49293e6ef51980f6aae2a48ee95f67ff4d073549e4eb58b5ad83e019c49341196554bf4244ad0e56809615741e680bbf66a01340d'
end

AcceleratedClaims::Application.config.secret_key_base = ENV['SECRET_KEY_BASE']
