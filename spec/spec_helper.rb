require "simplecov"
SimpleCov.start do
  command_name "protosite"

  filters.clear

  add_filter { |src| !(src.filename =~ /protosite\//) }
  add_filter [
    "vendor", # gems are installed here
  ]
end

ENV["RAILS_ENV"] ||= "test"
require_relative "dummy/config/environment"
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "capybara/rspec"

Dir[File.expand_path("../support/**/*.rb", __FILE__)].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Warden::Test::Helpers

  config.color = true
  config.use_transactional_fixtures = true

  config.after do
    Warden.test_reset!
  end
end
