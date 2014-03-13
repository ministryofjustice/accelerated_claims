class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def redirect_to_with_protocol action, options={}
    redirect_to url_for( options.merge(action: action, protocol: (Rails.env.production? ? 'https' : 'http') ) )
  end
end
