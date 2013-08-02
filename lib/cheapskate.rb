require "cheapskate/version"
require "cheapskate/engine"
require "cheapskate/adapter"

module Cheapskate
  def self.included(controller)
    controller.send :include, Cheapskate::Adapter
  end

  PRODUCTION_HTTP_HOST = ''
  PRODUCTION_HTTPS_HOST = ''

  def production_url_options
    {
      :http => {
        :protocol => 'http',
        :host => PRODUCTION_HTTP_HOST
      },

      :https => {
        :protocol => 'https',
        :host => PRODUCTION_HTTPS_HOST
      }
    }
  end

  def development_url_options
    {
      :http => {
        :protocol => 'http',
        :host => 'localhost',
        :port => 3000
      },

      :https => {
        :protocol => 'http',
        :host => 'localhost',
        :port => 8000
      }
    }
  end

  def register
    create_user(params)
    login()
  end

  def login
    user = find_user(params)
    if user.nil?
      alert('That user does not exist.')
      return redirect_to(login_path)
    end

    if !authenticate_user(user, params)
      alert('You have entered an incorrect password.')
      return redirect_to(login_path)
    end

    login = create_single_use_login!(user)
    redirect_to(complete_login_url(url_options_for_protocol(:http), :token => login.token))
  end

  def complete_login
    login = get_single_use_login(params[:token])
    if login.nil?
      alert('Unable to verify login. Try again?')
      redirect_to(login_path)
    end

    login_user(login.user)
    alert("Welcome, #{user_name(user)}!")
    redirect_to(root_path)
  end

  def url_options_for_protocol(protocol)
    if Rails.env.production?
      production_url_options()[protocol]
    else
      development_url_options()[protocol]
    end
  end
end
