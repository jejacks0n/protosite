module Protosite
  module Mutations
    class CreatePage < BaseMutation
      argument :data, String, required: true

      type Types::PageType

      def resolve(**args)
        args[:data] = JSON.parse(args[:data])
        page = Page.create_from_data!(args)

        broadcast(:page_created, page, args: { id: page.to_param })
        page
      end
    end
  end
end
