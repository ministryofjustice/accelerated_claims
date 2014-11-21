require 'email_validator'

class Feedback
  include ActiveModel::Model

  attr_accessor :difficulty_feedback
  attr_accessor :improvement_feedback
  attr_accessor :satisfaction_feedback
  attr_accessor :help_feedback
  attr_accessor :other_help

  validates :difficulty_feedback, length: { maximum: 5000 }
  validates :improvement_feedback, length: { maximum: 5000 }
  validates :satisfaction_feedback, length: { maximum: 35 }
  validates :help_feedback, length: { maximum: 75 }
  validates :other_help, length: { maximum: 5000 }

  attr_accessor :email
  attr_accessor :user_agent

  validates :email, email: true, if: ->(f) { f.email.present? }
  validates :email, length: { maximum: 500 }

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
    :help_feedback,
    :other_help].map do |field|
      "#{field}: #{send(field)}"
    end.join("\n\n")
  end

  def error_messages
    errors.messages.each_with_object({}) do |parts, hash|
      field = parts.first
      message = parts.last
      hash["feedback_#{field}_error"] = message
    end
  end

end
