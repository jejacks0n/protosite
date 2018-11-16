require "protosite/mutations/base_mutation"
require "protosite/mutations/create_user"
require "protosite/mutations/update_current_user"
require "protosite/mutations/create_page"
require "protosite/mutations/update_page"
require "protosite/mutations/remove_page"
require "protosite/mutations/publish_page"

module Protosite
  module Types
    class Mutation < Types::BaseType
      description("All mutations for the Protosite API.")

      field :create_user, mutation: Mutations::CreateUser
      field :update_current_user, mutation: Mutations::UpdateCurrentUser

      field :create_page, mutation: Mutations::CreatePage
      field :update_page, mutation: Mutations::UpdatePage
      field :remove_page, mutation: Mutations::RemovePage
      field :publish_page, mutation: Mutations::PublishPage
    end
  end
end
