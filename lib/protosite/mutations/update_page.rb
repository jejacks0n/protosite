module Protosite
  module Mutations
    class UpdatePage < BaseMutation
      argument :id, ID, required: true
      argument :data, Types::JsonType, required: true

      type Types::PageType

      def resolve(**args)
        data = JSON.parse(args[:data])
        page = Page.find(args[:id]).tap do |r|
          r.add_version!(data)
        end

        broadcast(:page_updated, page, args: { id: page.to_param })
        page
      end
    end
  end
end
