class W3cValidationResult
  include ActiveModel::Model

  attr_accessor :result
  attr_accessor :errors
  attr_accessor :message
end
