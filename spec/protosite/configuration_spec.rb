require "spec_helper"

describe Protosite::Configuration do
  subject { described_class }

  after do
    subject.mount_at = "/protosite"
  end

  it "has the default configuration" do
    expect(subject.mount_at).to eq "/protosite"
    expect(subject.cookie_expiration).to eq 30.minutes

    expect(subject.parent_controller).to eq "ActionController::Base"
    expect(subject.parent_record).to eq "ActiveRecord::Base"
    expect(subject.parent_connection).to eq "ActionCable::Connection::Base"
    expect(subject.parent_channel).to eq "ActionCable::Channel::Base"
  end

  it "allows setting various configuration options" do
    subject.mount_at = "/protosite_is_awesome"
    expect(subject.mount_at).to eq("/protosite_is_awesome")
  end
end
