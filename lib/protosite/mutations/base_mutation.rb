module Protosite
  module Mutations
    class BaseMutation < GraphQL::Schema::Mutation
      include Types::Common
    end
  end
end
