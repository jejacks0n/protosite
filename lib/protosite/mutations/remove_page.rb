module Protosite
  module Mutations
    class RemovePage < BaseMutation
      argument :id, ID, required: true

      type Types::PageType

      def resolve(**args)
        page = Page.find(args[:id]).tap do |r|
          r.destroy!
        end

        broadcast(:page_removed, page, args: { id: page.to_param })
        page
      end
    end
  end
end
