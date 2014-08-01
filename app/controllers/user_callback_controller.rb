require 'zendesk_helper'

class UserCallbackController < ApplicationController

  def new
    session[:return_to] = request.referrer unless referrer_is_feedback_form?
    @page_title = 'Make a claim to evict tenants - ask for technical help'
    @user_callback = UserCallback.new
  end

  def create
    @user_callback = UserCallback.new(user_callback_params)
    success_message = 'Thank you we will call you back during the next working day between 9am and 5pm.'
    send_to_zendesk @user_callback, :callback_request, success_message
  end

  private

  def user_callback_params
    params.require(:user_callback).permit(:name, :phone, :description)
  end

end
