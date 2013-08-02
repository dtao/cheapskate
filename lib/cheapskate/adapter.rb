module Cheapskate
  module Adapter
    def self.included(base)
      base.class_eval do
        def self.already_defined?(method)
          result = self.instance_methods.include?(method)
          puts "#{method} already defined in #{self}: #{result}"
          result
        end

        # Methods to override
        def alert(message)
          flash[:notice] = message
        end unless already_defined?(:alert)

        def create_user(params)
          User.create!(params.require(:user).permit(:name, :email, :password, :password_confirmation))
        end unless already_defined?(:create_user)

        def find_user(params)
          User.find_by_email(params[:email])
        end unless already_defined?(:find_user)

        def authenticate_user(user, params)
          user.authenticate(params)
        end unless already_defined?(:authenticate_user)

        def user_name(user)
          user.name
        end unless already_defined?(:user_name)

        def create_single_use_login!(user)
          SingleUseLogin.create!(:user => user)
        end unless already_defined?(:create_single_use_login!)

        def get_single_use_login(token)
          SingleUseLogin.find_by_token(token)
        end unless already_defined?(:get_single_use_login)

        def login_user(user)
          session[:user_id] = user.id
        end unless already_defined?(:login_user)
      end
    end
  end
end
