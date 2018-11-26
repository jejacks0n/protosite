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

Bundler.require(*Rails.groups)
require "protosite"

module Dummy
  class Application < Rails::Application
    config.load_defaults 5.2

    config.eager_load = Rails.env.production?
    config.cache_classes = !Rails.env.production?
    config.consider_all_requests_local = Rails.env.development?
  end
end

class RootController < ActionController::Base
  helper Webpacker::Helper
  prepend_view_path(Rails.root.join("public"))

  def app
    render template: "app"
  end
end

Rails.application.initialize! unless Rails.application.instance_variable_get(:"@initialized")
Rails.application.routes.draw do
  get "/(*path)", to: "root#app", constraints: Proc.new { |req| req.format == :html }
end

require "webpacker/compiler"
class Webpacker::Compiler
  private

    def run_webpack
      logger.info "Compiling…"

      stdout, sterr, status = Dir.chdir(Rails.root) do
        Open3.capture3(webpack_env, "#{RbConfig.ruby} ./bin/webpack")
      end

      if status.success?
        logger.info "Compiled all packs in #{config.public_output_path}"
      else
        logger.error "Compilation failed:\n#{sterr}\n#{stdout}"
      end

      status.success?
    end
end
