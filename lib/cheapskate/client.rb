module Cheapskate
  class Client
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

    def store_user_in_session(user, session)
      session[:user_id] = user.id
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
  end
end
