module Protosite
  class Engine < ::Rails::Engine
    isolate_namespace Protosite

    routes do
      root to: "/protosite#execute", via: [:post]
    end

    config.app_middleware.use Warden::Manager do |config|
      config.default_strategies :protosite_token_strategy, :protosite_basic_strategy
      config.failure_app = AuthFailure
    end

    config.after_initialize do |app|
      Protosite::Engine.prepend_routes(app)
    end

    def self.prepend_routes(app)
      path = Protosite.configuration.mount_at
      app.routes.prepend do
        mount Protosite::Engine, at: path, as: "protosite"
        mount GraphiQL::Rails::Engine, at: "#{path}/graphiql", graphql_path: path if Rails.env.development?
      end
    end
  end
end
