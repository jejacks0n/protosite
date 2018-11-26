module Protosite
  module Types
    class PageType < BaseType
      field :id, ID, null: false
      field :slug, String, null: false
      field :sort, String, null: false
      field :data, Types::JsonType, null: false
      field :versions, [Types::JsonType], null: false
      field :parent, Types::PageType, null: true
      field :pages, [Types::PageType], null: true

      def parent
        Page.find_by(id: object.data["parent_id"] || object.parent_id)
      end

      # TODO: pages should be versioned too, so we'd need to query inside the json for that potentially.
      def pages
        object.children
      end
    end
  end
end
