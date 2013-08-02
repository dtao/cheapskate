require "cheapskate/version"
require "cheapskate/engine"
require "cheapskate/adapter"

module Cheapskate
  HTTP_PROTOCOL  = 'http'
  HTTP_HOST      = Rails.env.development? && 'localhost' || nil
  HTTP_PORT      = Rails.env.development? && 3000 || nil
  HTTPS_PROTOCOL = Rails.env.development? && 'http' || 'https'
  HTTPS_HOST     = Rails.env.development? && 'localhost' || nil
  HTTPS_PORT     = Rails.env.development? && 8000 || nil

  def self.included(controller)
    controller.class_eval do
      before_filter :set_notification

      def set_notification
        if params.include?(:notice)
          
      end
    end
  end

  def register
    user = create_user(params)
    login() unless handle_registration?(user)
  end

  def login
    user = find_user(params)
    if user.nil?
      return alert_and_redirect('That user does not exist.', login_path)
    end

    if !authenticate_user(user, params)
      return alert_and_redirect('You have entered an incorrect password.', login_path)
    end

    login = create_single_use_login!(user)
    alert_and_redirect("Welcome, #{user_name(user)}!", complete_login_url(url_options_for_protocol(:http), :token => login.token))
  end

  def complete_login
    login = get_single_use_login(params[:token])
    if login.nil?
      alert_and_redirect('Unable to verify login. Try again?', login_path)
    end

    login_user(login.user)
    alert_and_redirect("Welcome, #{user_name(user)}!", root_path)
  end

  def url_options_for_protocol(protocol)
    if protocol == :https
      {
        :protocol => HTTPS_PROTOCOL,
        :host => HTTPS_HOST,
        :port => HTTPS_PORT
      }
    else
      {
        :protocol => HTTP_PROTOCOL,
        :host => HTTP_HOST,
        :port => HTTP_PORT
      }
    end
  end
end
