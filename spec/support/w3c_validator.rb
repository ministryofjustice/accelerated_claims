require 'w3c_validators'

include W3CValidators

# options[:w3c_debug] = turn on debug output
def validate_view(response, options)
  WebMock.disable_net_connect!(:allow => [ /validator.w3.org/ ])
  @validator = MarkupValidator.new

  # turn on debugging messages
  @validator.set_debug!(true) if options[:w3c_debug]

  results = @validator.validate_text(response.body)

  if results.errors.length > 0 && options[:w3c_debug]
    puts 'Errors'
    puts '------------------'
    results.errors.each do |err|
      puts err.to_s
    end
    puts 'Debugging messages'
    puts '------------------'
    results.debug_messages.each do |key, value|
      puts "  #{key}: #{value}"
    end
  end
  results
end
