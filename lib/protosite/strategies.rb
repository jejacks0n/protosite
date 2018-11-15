module Protosite
  class TokenStrategy < ::Warden::Strategies::Base
    def valid?
      !!authentication_token
    end

    def authenticate!
      user = User.find_by(authentication_token: authentication_token)
      user ? success!(user) : fail!("strategies.protosite.token_strategy.failed")
    end

    private

      def authentication_token
        params["authentication_token"]
      end
  end

  class BasicStrategy < ::Warden::Strategies::Base
    def valid?
      auth.provided? && auth.basic? && auth.credentials
    end

    def authenticate!
      email, password = auth.credentials
      user = User.find_by(email: email)
      user && user.authenticate(password) ? success!(user) : fail!("strategies.protosite.basic_auth.failed")
    end

    private

      def auth
        @auth ||= Rack::Auth::Basic::Request.new(env)
      end
  end
end
