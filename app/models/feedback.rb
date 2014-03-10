require 'email_validator'

class Feedback
  include ActiveModel::Model

  attr_accessor :text
  attr_accessor :email
  attr_accessor :referrer
  attr_accessor :user_agent

  validates_presence_of :text
  validates :email, email: true, if: ->(f) { f.email.present? }

  def name_for_feedback
    if email.present?
      'Unknown'
    else
      'anonymous feedback'
    end
  end

  def email_or_anonymous_placeholder
    if email.present?
      email
    else
      ENV['ANONYMOUS_PLACEHOLDER_EMAIL']
    end
  end
end
