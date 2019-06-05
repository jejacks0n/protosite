require "singleton"

module Protosite
  class Configuration
    include Singleton

    cattr_accessor :mount_at

    @@mount_at = "/protosite"

    cattr_accessor :parent_controller, :parent_record, :parent_connection, :parent_channel

    @@parent_controller = "ActionController::Base"
    @@parent_record = "ActiveRecord::Base"
    @@parent_connection = "ActionCable::Connection::Base"
    @@parent_channel = "ActionCable::Channel::Base"
  end

  mattr_accessor :configured, :configuration
  @@configured = false
  @@configuration = Configuration

  def self.configure
    yield @@configuration
    @@configured = true
  end
end
