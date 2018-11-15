module Protosite
  module Mutations
    autoload :UpdateCurrentUser, "protosite/mutations/update_current_user"
    autoload :UpdatePage, "protosite/mutations/update_page"

    class BaseMutation < GraphQL::Schema::Mutation
      include ObjectCommon
    end
  end
end
