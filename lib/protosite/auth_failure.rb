module Protosite
  class AuthFailure < ActionController::Metal
    def self.call(env)
      @respond ||= action(:respond)
      @respond.call(env)
    end

    def respond
      self.headers["WWW-Authenticate"] = "Basic" unless request.env["REQUEST_METHOD"] == "DELETE"
      self.headers["Content-Type"] = "application/json; charset=utf-8"
      self.response_body = { errors: "that action requires that you authenticate first" }.to_json
      self.status = 401
    end
  end
end
