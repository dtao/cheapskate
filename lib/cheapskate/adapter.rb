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
        def alert_and_redirect(message, path)
          uri = URI(path)
          if uri.absolute? && uri.host != request.host
            notice = create_single_use_notice!(message)
            uri.query = add_to_query(uri.query, :notice => notice.token)
          else
            flash[:notice] = message
          end

          redirect_to(uri.to_s)
        end unless already_defined?(:alert_and_redirect)

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

        def create_single_use_notice!(message)
          SingleUseNotice.create!(:message => message)
        end unless already_defined?(:create_single_use_notice!)

        def login_user(user)
          session[:user_id] = user.id
        end unless already_defined?(:login_user)

        # Callbacks
        def handle_registration?(user)
          return false
        end

        # No need to overrides these
        def add_to_query(query, parameters)
          query ||= ''
          start = query.length > 0 ? '&' : ''
          query + start + parameters.map { |name, value| "#{URI.escape(name)}=#{URI.escape(value)}" }.join('&')
        end
      end
    end
  end
end
