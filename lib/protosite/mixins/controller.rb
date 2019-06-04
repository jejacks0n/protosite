require "webpacker"

module Protosite
  module Mixins
    module Controller
      extend ActiveSupport::Concern

      included do
        helper_method :protosite_data, :current_user
      end

      protected

        def protosite_data(depth: 1)
          data = pages(depth: depth)
          return data unless current_user
          data.merge("currentUser": serialized_user)
        end

        def current_user
          @current_user ||= begin
            if cookies.signed["protosite_user.id"]
              user = Protosite::User.find_by(id: cookies.signed["protosite_user.id"])
            end
            user ||= request.env["warden"].authenticate
            set_user_cookie(user) if user
            user
          end
        end

      private

        def pages(depth: 1)
          query = "__query__"
          depth.times { query.gsub!("__query__", "pages {id, slug, data, __query__}") }
          res = Protosite::Schema.run(query.gsub("__query__", ""))
          res.dig("data")
        end

        def serialized_user
          res = Protosite::Schema.run("currentUser {id, email, name, pack, permissions}", current_user: current_user)
          res.dig("data", "currentUser")
        end

        def set_user_cookie(user)
          cookies.signed["protosite_user.id"] = user["id"]
          cookies.signed["protosite_user.expires_at"] = Protosite.configuration.cookie_expiration
        end
    end
  end
end
