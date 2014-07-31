require 'zendesk_helper'

class FeedbackController < ApplicationController

  def new
    session[:return_to] = request.referrer unless referrer_is_feedback_form?
    @page_title = 'Your feedback'
    @feedback ||= Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.valid?
      begin
        ZendeskHelper.send_to_zendesk(@feedback) unless @feedback.test?

        return_to notice: 'Thanks for your feedback.'
      rescue ZendeskAPI::Error::NetworkError
        flash[:error] = 'Problems sending your feedback. Please try again later.'
        render :new
      end
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