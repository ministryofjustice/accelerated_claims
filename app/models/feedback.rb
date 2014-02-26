require 'email_validator'

class Feedback
  include ActiveModel::Model

  attr_accessor :text
  attr_accessor :email

end
