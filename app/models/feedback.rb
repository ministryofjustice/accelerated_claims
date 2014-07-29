require 'email_validator'

class Feedback
  include ActiveModel::Model

  attr_accessor :difficulty_feedback
  attr_accessor :improvement_feedback
  attr_accessor :satisfaction_feedback
  attr_accessor :help_feedback

  attr_accessor :email
  attr_accessor :user_agent

  validates :email, email: true, if: ->(f) { f.email.present? }

  TEST_TEXT = 'test text'

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

  def test?
    difficulty_feedback == TEST_TEXT
  end

  def text
    [:difficulty_feedback,
    :improvement_feedback,
    :satisfaction_feedback,
    :help_feedback].map do |field|
      "#{field}: #{send(field)}"
    end.join("\n\n")
  end
end
