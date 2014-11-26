class W3cValidationResult
  include ActiveModel::Model

  attr_accessor :result
  attr_accessor :errors
  attr_accessor :message

  attr_accessor :timeout
  attr_accessor :fails
  attr_accessor :passes

  def initialize
    self.fails=0
    self.timeout=0
    self.passes=0
  end

  def increment_fail
    self.fails = self.fails+1
  end
  def increment_passes
    self.passes = self.passes+1
  end
  def increment_errors
    self.errors = self.errors+1
  end

  def outcome
    if self.fails > 0
      'Validation failed'
    elsif self.timeout>0
      'Validation passed with timeouts'
    else
      'Validation passed'
    end
  end
end