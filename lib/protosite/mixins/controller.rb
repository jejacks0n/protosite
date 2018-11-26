module Protosite
  module Mixins
    module Controller
      extend ActiveSupport::Concern

      included do
        helper_method :pages
      end

      protected

        def pages(depth: 1)
          query = "__query__"
          depth.times { query.gsub!("__query__", "pages {id, slug, data, __query__}") }
          Protosite::Schema.run(query.gsub("__query__", ""))["data"]
        end

      private

        def current_user
          @current_user ||= begin
            user = Protosite::User.find_by(id: cookies.signed["protosite_user.id"]) if cookies.signed["protosite_user.id"]
            user ||= request.env["warden"].authenticate
            set_user_cookie(user) if user
            user
          end
        end

        def set_user_cookie(user)
          cookies.signed["protosite_user.id"] = user.id
          cookies.signed["protosite_user.expires_at"] = Protosite.configuration.cookie_expiration
        end
    end
  end
end
