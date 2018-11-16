module Protosite
  module Types
    class Subscription < Types::BaseType
      description("All Protosite event subscriptions.")

      field :notification, Types::NotificationType, null: true

      field :user_created, Types::UserType, null: true
      field :user_updated, Types::UserType, null: true do
        argument :id, ID, required: true
      end

      field :page_created, Types::PageType, null: true
      field :page_removed, Types::PageType, null: true
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
  end
end
