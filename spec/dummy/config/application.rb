ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../../Gemfile", __dir__)
require "bundler/setup" # Set up gems listed in the Gemfile.

require "rails"
# Pick the frameworks you want:
# require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require "protosite"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.eager_load = Rails.env.production?
    config.cache_classes = !Rails.env.production?
    config.consider_all_requests_local = !Rails.env.production?

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end

class ApplicationController < ActionController::Base
  def welcome
    render plain: "welcome", layout: false
  end
end

Rails.application.initialize! unless Rails.application.instance_variable_get(:"@initialized")
Rails.application.routes.draw do
  match "/(*path)", to: "application#welcome", via: [:get, :put, :post, :delete]
end
