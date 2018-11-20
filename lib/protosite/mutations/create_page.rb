module Protosite
  module Mutations
    class CreatePage < BaseMutation
      argument :data, Types::JsonType, required: true

      type Types::PageType

      def resolve(**args)
        authorize!(current_user, :create_page)

        page = Page.create_from_data!(args)

        broadcast(:page_created, page)
        page
      end
    end
  end
end
