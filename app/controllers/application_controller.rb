class ApplicationController < ActionController::Base
  rescue_from ActionController::InvalidAuthenticityToken, with: :expired_session_redirection

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null session instead.
  if ENV['CC_NO_CSRF'].nil?
    protect_from_forgery with: :exception, except: :expire_session
  end

  def redirect_to_with_protocol action, options={}
    redirect_to url_for( options.merge(action: action, protocol: protocol) )
  end

  def return_to options={}
    redirect_to (session[:return_to] || root_path), options.merge( protocol: protocol )
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

  unless Rails.env.production?
    def invalid_access_token
      raise ActionController::InvalidAuthenticityToken
    end
  end

  protected

  def referrer_is_feedback_form?
    request.referrer.to_s[/#{feedback_path}|#{technical_help_path}/]
  end

  def send_to_zendesk item, request_type, success_message
    if item.valid?
      begin
        ZendeskHelper.send(request_type, item) unless item.test?
        return_to notice: success_message
      rescue ZendeskAPI::Error::NetworkError
        flash[:error] = 'There were problems sending your feedback. Please try again later.'
        render :new
      end
    else
      @errors = item.errors
      @error_messages = item.error_messages
      render :new
    end
  end

  private

  def expired_session_redirection
    unless Rails.env.development?
      message = "Rescued invalid Authenticity Token. They are now being redirected."
      severity = 'warn'
      fields = { :message => message, :level => severity }
      event = LogStash::Event.new('@source' => 'unknown', '@fields' => fields, '@tags' => ['log'])
      LogStasher.logger << "#{event.to_json}\n"
      redirect_to url_for(action: :expired, controller: :static)
    else
      raise
    end
  end

  def protocol
    (Rails.env.production? ? 'https' : 'http')
  end

end
