WHITELISTED_KEYS_MATCHER = /^action$/.freeze
SANITIZED_VALUE = '[FILTERED]'.freeze

AcceleratedClaims::Application.config.filter_parameters << lambda do |key, value|
  unless Rails.env.development?
    unless key.match(WHITELISTED_KEYS_MATCHER)
      value ? value.replace(SANITIZED_VALUE) : ''
    end
  end
end
