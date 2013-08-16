module Cheapskate
  module Client
    def self.included(client_class)
      Cheapskate::CONFIG['CLIENT_CLASS'] = client_class
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

    def store_user_in_session(user, session)
      session[:user_id] = user.id
    end

    def alert_notice(controller, message)
      controller.flash[:notice] = message
    end

    def alert_error(controller, message)
      alert_notice(controller, message)
    end
  end
end
