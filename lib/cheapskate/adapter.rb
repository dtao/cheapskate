module Cheapskate
  module Adapter
    def alert_and_redirect(message, path)
      uri = URI(path)
      if uri.absolute? && uri.host != request.host
        notice = create_single_use_notice!(message)
        uri.query = add_to_query(uri.query, :notice => notice.token)
      else
        flash[:notice] = message
      end

      redirect_to(uri.to_s)
    end

    def create_user(params)
      User.create!(params.require(:user).permit(:name, :email, :password, :password_confirmation))
    end

    def find_user(params)
      User.find_by_email(params[:email])
    end

    def authenticate_user(user, params)
      user.authenticate(params[:password])
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

    def create_single_use_notice!(message)
      SingleUseNotice.create!(:message => message)
    end

    def get_single_use_notice(token)
      SingleUseNotice.find_by_token(token)
    end

    def login_user(user)
      session[:user_id] = user.id
    end

    # Callbacks
    def on_user_created(user); end

    # No need to override these
    def add_to_query(query, parameters)
      query ||= ''
      start = query.length > 0 ? '&' : ''
      query + start + parameters.map { |name, value| "#{URI.escape(name)}=#{URI.escape(value)}" }.join('&')
    end
  end
end
