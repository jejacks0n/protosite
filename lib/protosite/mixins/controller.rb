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
            user = request.env["warden"].authenticate
            User.find(user["id"]) if user
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
    end
  end
end
