require "cheapskate/version"

module Cheapskate
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
      alert('The specified user name does not exist.')
      return redirect_to(login_path)
    end

    if !authenticate_user(user, params)
      alert('You have entered an incorrect password.')
      return redirect_to(login_path)
    end

    login = create_single_use_login!(user)
    redirect_to(complete_login_url(url_options(:http), :token => login.token))
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

  def url_options(protocol)
    if Rails.env.production?
      production_url_options()[protocol]
    else
      development_url_options()[protocol]
    end
  end

  # Methods to override
  def alert(message)
    flash[:notice] = message
  end

  def create_user(params)
    User.create!(params.require(:user).permit(:name, :email, :password, :password_confirmation))
  end

  def find_user(params)
    User.find_by_email(params[:email])
  end

  def authenticate_user(user, params)
    user.authenticate(params)
  end

  def user_name(user)
    user.name
  end

  def create_single_use_login!(user)
    SingleUseLogin.create!(:user => user)
  end

  def get_single_use_login(token)
    SingleUseLogin.find_by_token(token)
  end

  def login_user(user)
    session[:user_id] = user.id
  end
end
