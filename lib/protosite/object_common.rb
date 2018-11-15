module Protosite
  module ObjectCommon
    extend ActiveSupport::Concern

    def current_user
      context[:current_user]
    end

    def broadcast(event, resource, options = {})
      Schema.broadcast(event, resource, options)
    end
  end
end
