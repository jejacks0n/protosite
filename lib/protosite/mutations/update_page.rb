module Protosite
  module Mutations
    class UpdatePage < BaseMutation
      argument :id, ID, required: true
      argument :title, String, required: false

      type Types::PageType

      def resolve(**args)
        page = Page.find(args[:id]).tap do |r|
          r.update!(args)
        end

        broadcast(:page_updated, page, args: { id: page.to_param })

        page
      end
    end
  end
end
