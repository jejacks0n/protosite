module Protosite
  module Connection
    extend ActiveSupport::Concern

    included do
      identified_by :current_user
    end

    def current_user
      @current_user ||= begin
        user = Protosite::User.find_by(id: cookies.signed["protosite_user.id"])
        raise(UnauthorizedError, "must be authenticated") unless user
        user
      end
    end
  end
end
