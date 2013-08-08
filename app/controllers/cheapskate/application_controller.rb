module Cheapskate
  class ApplicationController < ActionController::Base
    include Cheapskate::Adapter

    before_filter :check_for_notification

    def register
      user = create_user(params)
      on_user_created(user)
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

      user = login.get_user_and_destroy!
      login_user(user)
      alert_and_redirect("Welcome, #{user_name(user)}!", app.root_path)
    end

    def url_options_for_protocol(protocol)
      if protocol == :https
        {
          :protocol => Cheapskate::HTTPS_PROTOCOL,
          :host => Cheapskate::HTTPS_HOST,
          :port => Cheapskate::HTTPS_PORT
        }
      else
        {
          :protocol => Cheapskate::HTTP_PROTOCOL,
          :host => Cheapskate::HTTP_HOST,
          :port => Cheapskate::HTTP_PORT
        }
      end
    end

    private

    def check_for_notification
      if params.include?(:notice)
        @notification = get_single_use_notice(params.delete(:notice))
        flash[:notice] = @notification.get_message_and_destroy!

        redirect_to(request.path, params)
      end
    end
  end
end
