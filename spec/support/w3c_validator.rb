require 'w3c_validators'

include W3CValidators

def validate_view(response, options={})
  WebMock.disable_net_connect!(:allow => [ /validator.w3.org/ ])
  @validator = MarkupValidator.new

  # turn on debugging messages
  @validator.set_debug!(true) if options[:w3c_debug]
  outcome = W3cValidationResult.new
  outcome.errors={}

  tries = options[:attempts] || 3
  attempt = 0

  begin
    attempt += 1
    begin
      results = @validator.validate_text(response.body)
      if results.errors.length > 0
        outcome.result='fail'
        outcome.errors = results.errors
        outcome.message = "\nValidation failed"
        outcome.message += "\nErrors"
        outcome.message += "\n------------------"
        results.errors.each do |err|
          outcome.message += "\n#{err.to_s}"
        end
      else
        outcome.result = 'pass'
      end
    rescue => e
      outcome.result='error'
      outcome.message =  "\nError while validating"
      outcome.message += "\n----------------------"
      outcome.message += "\n#{e.message}"
    end
  end while outcome.result == 'error' &&  attempt < tries
  if attempt==tries
    outcome.result='timeout'
  end
  outcome
end
