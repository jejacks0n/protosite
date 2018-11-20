module Protosite
  module Mutations
    class RemovePage < BaseMutation
      argument :id, ID, required: true

      type Types::PageType

      def resolve(**args)
        authorize!(current_user, :remove_page)

        page = Page.find(args[:id]).tap do |r|
          r.destroy!
        end

        broadcast(:page_removed, page)
        page
      end
    end
  end
end
