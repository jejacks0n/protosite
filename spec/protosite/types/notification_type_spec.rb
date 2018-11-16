require "spec_helper"

describe Protosite::Types::NotificationType do
  subject { described_class }

  it { is_expected.to have_field(:message).of_type("String!") }
end
