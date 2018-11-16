module Protosite
  module Mutations
    class UpdateCurrentUser < BaseMutation
      argument :email, String, required: false
      argument :password, String, required: false

      type Types::UserType

      def resolve(**args)
        current_user.update!(args)

        broadcast(:user_updated, current_user, args: { id: current_user.to_param })
        current_user
      end
    end
  end
end
