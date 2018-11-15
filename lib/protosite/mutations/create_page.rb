module Protosite
  module Mutations
    class CreatePage < BaseMutation
      argument :title, String, required: false

      type Types::PageType

      def resolve(**args)
        page = Page.create!(args.merge(created_by: current_user))

        broadcast(:page_created, oage, args: { id: page.to_param })

        page
      end
    end
  end
end
