require 'w3c_validators'

include W3CValidators

def test_present?(options)
  options[:test_name].present?
end

def output_test?(options)
  options[:test_name] if test_present?(options)
end

def validate_view(response, options = {})
  WebMock.disable_net_connect!(allow: [/validator.w3.org/])
  @validator = MarkupValidator.new

  # turn on debugging messages
  @validator.set_debug!(true) if options[:w3c_debug]
  outcome = W3cValidationResult.new
  outcome.errors = {}

  tries = options[:attempts] || 3
  attempt = 0

  begin
    attempt += 1
    begin
      results = @validator.validate_text(response.body)
      if results.errors.length > 0
        outcome.result = 'fail'
        outcome.errors = results.errors
        outcome.message = "\nValidation failed for #{output_test?(options)}"
        outcome.message += "\nErrors"
        outcome.message += "\n------------------"
        results.errors.each do |err|
          outcome.message += "\n#{err}"
        end
      else
        outcome.result = 'pass'
      end
    rescue => e
      outcome.result = 'error'
      outcome.message =  "\nValidation error while processing"
      outcome.message += "\n#{options[:test_name]}" if test_present?(options)
      outcome.message += "\n----------------------"
      outcome.message += "\n#{e.message}"
      outcome.message += "\non #{attempt.ordinalize} pass"
      outcome.message += "\n----------------------"
    end
  end while outcome.result == 'error' &&  attempt < tries
  outcome.result = 'timeout' if attempt == tries
  outcome
end
