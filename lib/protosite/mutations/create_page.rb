module Protosite
  module Mutations
    class CreatePage < BaseMutation
      argument :data, Types::JsonType, required: true

      type Types::PageType

      def resolve(**args)
        page = Page.create_from_data!(args)

        broadcast(:page_created, page, args: { id: page.to_param })
        page
      end
    end
  end
end
