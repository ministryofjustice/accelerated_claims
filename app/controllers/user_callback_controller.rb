require 'zendesk_helper'

class UserCallbackController < ApplicationController

  def new
    @page_title = 'Make a claim to evict tenants - ask for technical help'
    @user_callback = UserCallback.new
  end

  def create
    @user_callback = UserCallback.new(user_callback_params)

    if @user_callback.valid?
      ZendeskHelper.callback_request(@user_callback)
      msg = 'Thank you we will call you back during the next working day between 9am and 5pm.'
      redirect_to root_path, notice: msg, protocol: (Rails.env.production? ? 'https' : 'http')
    else
      render :new
    end
  end

  private
  def user_callback_params
    params.require(:user_callback).permit(:name, :phone, :description)
  end
end
