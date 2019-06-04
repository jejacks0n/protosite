ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../../Gemfile", __dir__)
require "bundler/setup" # Set up gems listed in the Gemfile.

require "rails"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"

Bundler.require(*Rails.groups)
require "protosite"
require_relative "webpack/compiler_patch"

module Dummy
  class Application < Rails::Application
    config.load_defaults 5.2

    config.eager_load = Rails.env.production?
    config.cache_classes = !Rails.env.production?
    config.consider_all_requests_local = Rails.env.development?
    config.action_dispatch.cookies_serializer = :json
  end
end

Rails.application.initialize! unless Rails.application.instance_variable_get(:"@initialized")
Rails.application.routes.draw do
  root to: "protosite#app"
  get "*path", to: "protosite#app", constraints: Proc.new { |req| ["text/html", "*/*"].include?(req.format.to_s) }
end
