class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null session instead.
  if Rails.env.production? || ENV['CC_NO_CSRF'] != '1'
    protect_from_forgery with: :exception
  end

  def redirect_to_with_protocol action, options={}
    redirect_to url_for( options.merge(action: action, protocol: (Rails.env.production? ? 'https' : 'http') ) )
  end
end
