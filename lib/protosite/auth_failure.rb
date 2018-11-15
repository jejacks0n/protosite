module Protosite
  class AuthFailure < ActionController::Metal
    def self.call(env)
      @respond ||= action(:respond)
      @respond.call(env)
    end

    def respond
      self.headers["WWW-Authenticate"] = "Basic"
      self.response_body = "You need to authenticate"
      self.status = 401
    end
  end
end
