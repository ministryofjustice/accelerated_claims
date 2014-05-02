WHITELISTED_KEYS_MATCHER = /^action$/.freeze
SANITIZED_VALUE = '[FILTERED]'.freeze

config.filter_parameters << lambda do |key, value|
  unless key.match(WHITELISTED_KEYS_MATCHER)
    value.replace(SANITIZED_VALUE)
  end
end
