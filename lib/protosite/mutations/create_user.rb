module Protosite
  module Mutations
    class CreateUser < BaseMutation
      argument :name, String, required: true
      argument :email, String, required: true
      argument :password, String, required: true

      type Types::UserType

      def resolve(**args)
        authorize!(current_user, :admin)

        user = User.create!(args)

        broadcast(:user_created, user)
        user
      end
    end
  end
end
