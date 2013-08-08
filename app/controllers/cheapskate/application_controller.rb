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
      alert_and_redirect("Thank you for registering.", Cheapskate::ROOT_PATH)
    end

    def login
      user = @client.find_user(params)
      if user.nil?
        return alert_and_redirect('That user does not exist.', login_path)
      end

      if !@client.authenticate_user(user, params)
        return alert_and_redirect('You have entered an incorrect password.', login_path)
      end

      login = @client.create_single_use_login!(user)
      redirect_to(logged_in_url(url_options_for_protocol(:http).merge(:token => login.token)))
    end

    def complete_login
      login = @client.get_single_use_login(params[:token])
      if login.nil?
        alert_and_redirect('Unable to verify login. Try again?', login_path)
      end

      user = login.get_user_and_destroy!
      store_user_in_session(user, session)
      alert_and_redirect("Welcome, #{user_name(user)}!", Cheapskate::ROOT_PATH)
    end

    protected

    def alert_and_redirect(message, path)
      uri = URI(path)
      if uri.absolute? && uri.host != request.host
        notice = @client.create_single_use_notice!(message)
        uri.query = add_to_query(uri.query, :notice => notice.token)
      else
        flash[:notice] = message
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
      @client = Cheapskate::CLIENT_CLASS.new
    end

    def check_for_notification
      if params.include?(:notice)
        @notification = get_single_use_notice(params.delete(:notice))
        flash[:notice] = @notification.get_message_and_destroy!

        redirect_to(request.path, params)
      end
    end
  end
end
