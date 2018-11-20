module Protosite
  module Types
    autoload :JsonType, "protosite/types/json_type"
    autoload :Mutation, "protosite/types/mutation"
    autoload :NotificationType, "protosite/types/notification_type"
    autoload :PageType, "protosite/types/page_type"
    autoload :Query, "protosite/types/query"
    autoload :Subscription, "protosite/types/subscription"
    autoload :UserType, "protosite/types/user_type"

    module Common
      extend ActiveSupport::Concern

      def current_user
        context[:current_user]
      end

      def authorize!(user, action)
        raise(GraphQL::ExecutionError, "unauthenticated") unless user
        return true if user.admin?
        permissions = user.permissions
        (permissions.respond_to?(action) && permissions.send(action)) || raise(GraphQL::ExecutionError, "unauthorized")
      end

      def broadcast(event, resource, options = {})
        Schema.broadcast(event, resource, options)
      end
    end

    class BaseScalar < GraphQL::Schema::Scalar
      include Common
    end

    class BaseType < GraphQL::Schema::Object
      include Common

      class << self
        public :new # make new public again, which Object hides from us
      end
    end
  end
end
