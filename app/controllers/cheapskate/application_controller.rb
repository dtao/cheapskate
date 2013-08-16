module Cheapskate
  class ApplicationController < ActionController::Base
    # Typically (or so I read) you would make this a controller method and expose it via #helper;
    # HOWEVER, I want this method to be available both to me (ApplicationController) and the client
    # app. I'm guessing this is not the right approach. But step 1 is just getting it all to work.
    include Cheapskate::ApplicationHelper

    before_filter :initialize_client
    before_filter :check_for_notification

    def register
      user = @client.create_user(params)
      redirect_to(registered_url(url_options_for_protocol(:http)))
    end

    def complete_registration
      alert_and_redirect("Thank you for registering.", Cheapskate::CONFIG['ROOT_PATH'])
    end

    def login
      user = @client.find_user(params)
      if user.nil?
        return alert_and_redirect('That user does not exist.', login_path, :error)
      end

      if !@client.authenticate_user(user, params)
        return alert_and_redirect('You have entered an incorrect password.', login_path, :error)
      end

      login = SingleUseLogin.create!(:user => user)
      redirect_to(logged_in_url(url_options_for_protocol(:http).merge(:token => login.token)))
    end

    def complete_login
      login = SingleUseLogin.find_by_token(params[:token])
      if login.nil?
        alert_and_redirect('Unable to verify login. Try again?', login_path, :error)
      end

      user = login.get_user_and_destroy!
      @client.store_user_in_session(user, session)
      alert_and_redirect("Welcome, #{@client.user_name(user)}!", Cheapskate::CONFIG['ROOT_PATH'])
    end

    protected

    def alert_and_redirect(message, path, alert_type=:notice)
      uri = URI(path)
      if uri.absolute? && uri.host != request.host
        notice = SingleUseNotice.create!(:message => message)
        uri.query = add_to_query(uri.query, :notice => notice.token)
      else
        @client.send(:"alert_#{alert_type}", self, message)
      end

      logger.info("CHEAPSKATE - Redirecting...")
      logger.info("CHEAPSKATE - FROM: #{request.path}")
      logger.info("CHEAPSKATE - TO:   #{path}")
      logger.info("CHEAPSKATE - =>:   #{uri})")

      redirect_to(uri.to_s)
    end

    def add_to_query(query, parameters)
      query ||= ''
      start = query.length > 0 ? '&' : ''
      query + start + parameters.map { |name, value| "#{URI.escape(name)}=#{URI.escape(value)}" }.join('&')
    end

    private

    def initialize_client
      @client = Cheapskate::CONFIG['CLIENT_CLASS'].new
    end

    def check_for_notification
      if params.include?(:notice)
        @notification = SingleUseNotice.find_by_token(params.delete(:notice))
        @client.alert_notice(self, @notification.get_message_and_destroy!)

        redirect_to(request.path, params)
      end
    end
  end
end
