require 'zendesk_helper'

class FeedbackController < ApplicationController

  def new
    @page_title = 'Property repossession'
    @feedback ||= Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.valid?
      ZendeskHelper.send_to_zendesk(@feedback)
      redirect_to root_path, notice: 'Thanks for your feedback.'
    else
      render 'new'
    end
  end

  private
  def feedback_params
    params.require(:feedback).permit(:referrer, :text, :email, :user_agent)
  end
end