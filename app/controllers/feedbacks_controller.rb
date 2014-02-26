require 'zendesk_helper'

class FeedbacksController < ApplicationController
  def index
  end

  def new
    @page_title = 'Property repossession'
    @feedback ||= Feedback.new
  end

  def create
    redirect_to root_path, notice: 'Thanks for your feedback.'
  end

  private
  def feedback_params
    params.require(:feedback).permit(:referrer, :text, :email, :user_agent)
  end
end