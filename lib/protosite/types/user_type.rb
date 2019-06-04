require "webpacker"

module Protosite
  module Types
    class UserType < Protosite::Types::BaseType
      include Webpacker::Helper
      include ActionView::Helpers::AssetUrlHelper

      field :id, ID, null: false
      field :name, String, null: false
      field :email, String, null: false
      field :token, String, null: true
      field :pack, String, null: true
      field :permissions, Types::JsonType, null: true

      def token
        current_user.id == object.id ? object.authentication_token : nil
      end

      def pack
        object.admin? ? asset_pack_path("protosite.js") : nil
      end

      def permissions
        ret = object.permissions.hash.reject { |_k, v| !v }
        ret["admin"] = true if object.admin?
        ret
      end
    end
  end
end
