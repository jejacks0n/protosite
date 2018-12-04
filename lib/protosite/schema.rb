require "protosite/types/base_type"

module Protosite
  class Schema < GraphQL::Schema
    max_depth 10
    max_complexity 300
    default_max_page_size 20

    use GraphQL::Backtrace
    use GraphQL::Subscriptions::ActionCableSubscriptions

    mutation(Types::Mutation)
    query(Types::Query)
    subscription(Types::Subscription)

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

    def self.run(query, context = { current_user: nil })
      execute({ "query" => "query { #{query} }" }, context)
    end

    def self.execute(data, context)
      super(
        query: data["query"],
        variables: ensure_hash(data["variables"] || {}),
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
