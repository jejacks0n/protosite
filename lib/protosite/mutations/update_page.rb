module Protosite
  module Mutations
    class UpdatePage < BaseMutation
      argument :id, ID, required: true
      argument :data, Types::JsonType, required: true

      type Types::PageType

      def resolve(**args)
        authorize!(current_user, :create_page)

        page = Page.find(args[:id]).tap do |r|
          r.add_version!(args[:data])
        end

        broadcast(:page_updated, page)
        page
      end
    end
  end
end
