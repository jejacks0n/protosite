module Protosite
  module Types
    class UserType < Protosite::Types::BaseType
      field :id, ID, null: false
      field :name, String, null: false
      field :email, String, null: false
      # field :permissions, Types::JsonType, null: true
      #
      # def permissions
      #   ret = object.permissions.hash.reject { |_k, v| !v }
      #   ret["admin"] = true if object.admin?
      #   ret
      # end
    end
  end
end
