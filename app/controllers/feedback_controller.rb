require 'zendesk_helper'

class FeedbackController < ApplicationController

  def new
    @page_title = 'Your feedback'
    @feedback ||= Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.valid?
      ZendeskHelper.send_to_zendesk(@feedback) unless @feedback.test?
      redirect_to root_path, notice: 'Thanks for your feedback.', protocol: (Rails.env.production? ? 'https' : 'http')
    else
      render :new
    end
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