require 'w3c_validators'

include W3CValidators

# options[:w3c_debug] = turn on debug output
def validate_view(response, options)
  WebMock.disable_net_connect!(:allow => [ /validator.w3.org/ ])
  @validator = MarkupValidator.new

  # turn on debugging messages
  @validator.set_debug!(true) if options[:w3c_debug]
  outcome = W3cValidationResult.new
  outcome.errors={}
  begin
    results = @validator.validate_text(response.body)

    if results.errors.length > 0
      outcome.result='fail'
      if options[:w3c_debug]
        outcome.errors = results.errors
        outcome.message = 'Validation failed'
        outcome.message += 'Errors'
        outcome.message += '------------------'
        results.errors.each do |err|
          outcome.message += err.to_s
        end
        outcome.message += 'Debugging messages'
        outcome.message += '------------------'
        results.debug_messages.each do |key, value|
          outcome.message += "  #{key}: #{value}"
        end
        puts outcome.message
      end
    end
  rescue => e
    outcome.result='error'
    outcome.message =  'Error while validating'
    outcome.message += '----------------------'
    outcome.message += e.message
    puts outcome.message
  end
  outcome
end
