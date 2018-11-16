module Protosite
  module Types
    class Query < Types::BaseType
      description("All queries for the Protosite API.")

      field :current_user, Types::UserType, null: true
      field :pages, [Types::PageType], null: true

      field :page, Types::PageType, null: true do
        argument :id, ID, required: true
      end

      def pages
        Page.roots
      end

      def page(id:)
        Page.find(id)
      end
    end
  end
end
