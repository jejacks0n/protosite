module Protosite
  module Mutations
    class PublishPage < BaseMutation
      argument :id, ID, required: true

      type Types::PageType

      def resolve(**args)
        authorize!(current_user, :publish_page)

        page = Page.find(args[:id]).tap do |r|
          r.publish!
        end

        broadcast(:page_updated, page)
        page
      end
    end
  end
end
