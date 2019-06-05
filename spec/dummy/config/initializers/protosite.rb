Protosite.configure do |config|
  config.mount_at          = "/protosite"
  config.parent_controller = "ActionController::Base"
  config.parent_record     = "ActiveRecord::Base"
  config.parent_connection = "ActionCable::Connection::Base"
  config.parent_channel    = "ActionCable::Channel::Base"
end
