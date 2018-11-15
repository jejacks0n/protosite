require "graphql"
require "graphql/errors"
require "warden"
require "bcrypt"

require "protosite/version"
require "protosite/configuration"
require "protosite/strategies"
require "protosite/auth_failure"
require "protosite/schema"
require "protosite/engine"

Warden::Strategies.add(:protosite_token_strategy, Protosite::TokenStrategy)
Warden::Strategies.add(:protosite_basic_strategy, Protosite::BasicStrategy)
