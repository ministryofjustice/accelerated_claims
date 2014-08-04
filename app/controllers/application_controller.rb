class ApplicationController < ActionController::Base

  around_filter :clear_session_before_raising_to_app_signal

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null session instead.
  if ENV['CC_NO_CSRF'].nil?
    protect_from_forgery with: :exception
  end

  def redirect_to_with_protocol action, options={}
    redirect_to url_for( options.merge(action: action, protocol: protocol) )
  end

  def return_to options={}
    redirect_to (session[:return_to] || root_path), options.merge( protocol: protocol )
  end

  def heartbeat
    render text: ''
  end

  def expire_session
    if session
      reset_session
      if params["redirect"] == 'false'
        render text: ''
      else
        redirect_to root_path
      end
    end
  end

  protected

  def clear_session_before_raising_to_app_signal
    begin
      yield
    rescue => err
      reset_session if Rails.env.production?
      raise err
    end
  end

  def referrer_is_feedback_form?
    request.referrer.to_s[/#{feedback_path}|#{technical_help_path}/]
  end

  private

  def protocol
    (Rails.env.production? ? 'https' : 'http')
  end

end
