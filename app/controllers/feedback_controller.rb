require 'zendesk_helper'

class FeedbackController < ApplicationController

  def new
    session[:return_to] = request.referrer unless referrer_is_feedback_form?
    @page_title = 'Your feedback'
    @feedback ||= Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)

    success_message = 'Thanks for your feedback.'
    send_to_zendesk @feedback, :send_feedback, success_message
  end

  private
  def feedback_params
    params.require(:feedback).permit(:difficulty_feedback,
      :improvement_feedback,
      :satisfaction_feedback,
      :help_feedback,
      :other_help,
      :email, :user_agent)
  end
end