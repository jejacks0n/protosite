require "protosite/object_common"
require "protosite/mutations/base_mutation"
require "protosite/types/base_scalar"
require "protosite/types/base_type"

module Protosite
  class Schema < GraphQL::Schema
    max_depth 10
    max_complexity 300
    default_max_page_size 20

    use GraphQL::Backtrace
    use GraphQL::Subscriptions::ActionCableSubscriptions

    class Mutation < Types::BaseType
      field :update_current_user, mutation: Mutations::UpdateCurrentUser
      field :update_page, mutation: Mutations::UpdatePage
    end

    class Query < Types::BaseType
      field :current_user, Types::UserType, null: true
      field :pages, [Types::PageType], null: true

      field :page, Types::PageType, null: true do
        argument :id, ID, required: true
      end

      def pages
        Page.all.order(:sort)
      end

      def page(id:)
        Page.find(id)
      end
    end

    class Subscription < Types::BaseType
      field :notification, Types::NotificationType, null: true
      field :page_created, Types::PageType, null: true
      field :page_destroyed, Types::PageType, null: true

      field :user_updated, Types::UserType, null: true do
        argument :id, ID, required: true
      end

      field :page_updated, Types::PageType, null: true do
        argument :id, ID, required: true
      end

      def user_updated(id:)
        User.find(id)
      end

      def page_updated(id:)
        Page.find(id)
      end
    end

    mutation(Mutation)
    query(Query)
    subscription(Subscription)

    GraphQL::Errors.configure(self) do
      if defined?(ActiveRecord)
        rescue_from ActiveRecord::RecordNotFound do |_e|
          nil
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          msg = e.record.errors.full_messages.join("\n")
          GraphQL::ExecutionError.new(msg, options: { attributes: [e.record.errors] })
        end
      end

      rescue_from StandardError do |e|
        GraphQL::ExecutionError.new(
          Rails.env.development? ? "Error: #{e.message}" : "Error: unable to execute that query"
        )
      end
    end

    def self.execute(data, context)
      super(
        query: data["query"],
        variables: ensure_hash(data["variables"]),
        operation_name: data["operationName"],
        context: context
      )
    end

    def self.broadcast(event, resource, message: nil, args: {})
      subscriptions.trigger(event, args, resource)
      subscriptions.trigger(:notification, {}, { message: message }) if message
    end

    def self.ensure_hash(ambiguous)
      case ambiguous
      when String
        ambiguous.present? ? ensure_hash(JSON.parse(ambiguous)) : {}
      when Hash, ActionController::Parameters
        ambiguous
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{ambiguous}"
      end
    end
  end
end
