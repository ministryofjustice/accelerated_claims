require 'zendesk_helper'

class UserCallbackController < ApplicationController

  def new
    @user_callback = UserCallback.new
  end

  def create
    @user_callback = UserCallback.new(user_callback_params)

    if @user_callback.valid?
      ZendeskHelper.callback_request(@user_callback)
      redirect_to root_path, notice: "Thank you, we'll call you.", protocol: (Rails.env.production? ? 'https' : 'http')
    else
      render :new
    end
  end

  private
  def user_callback_params
    params.require(:user_callback).permit(:name, :phone, :description)
  end
end
