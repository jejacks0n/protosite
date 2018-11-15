module Protosite
  module Types
    class JsonType < BaseScalar
      def coerce_input(val, _ctx)
        JSON.parse(val)
      end

      def coerce_result(val, _ctx)
        JSON.dump(val)
      end
    end
  end
end
