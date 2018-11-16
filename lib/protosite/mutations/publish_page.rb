module Protosite
  module Mutations
    class PublishPage < BaseMutation
      argument :id, ID, required: true

      type Types::PageType

      def resolve(**args)
        page = Page.find(args[:id]).tap do |r|
          r.publish!
        end

        broadcast(:page_updated, page, args: { id: page.to_param })
        page
      end
    end
  end
end
