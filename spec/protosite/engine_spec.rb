require "spec_helper"

describe Protosite::Engine do
  subject { described_class }

  it "has been isolated with a name" do
    expect(subject.isolated?).to be(true)
    expect(subject.railtie_name).to eql("protosite")
  end
end
