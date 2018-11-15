module Protosite
  module Types
    class PageType < BaseType
      field :id, ID, null: false
      field :slug, String, null: false
      field :title, String, null: false
      # field :resources, [Types::XType], null: true

      # def resources
      #   object.resources
      # end
    end
  end
end
