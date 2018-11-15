module Protosite
  module Types
    autoload :JsonType, "protosite/types/json_type"
    autoload :NotificationType, "protosite/types/notification_type"
    autoload :PageType, "protosite/types/page_type"
    autoload :UserType, "protosite/types/user_type"

    class BaseType < GraphQL::Schema::Object
      include ObjectCommon

      class << self
        public :new # make new public again, which Object hides from us
      end
    end
  end
end
