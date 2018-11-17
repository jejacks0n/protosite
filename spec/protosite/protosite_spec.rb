require "spec_helper"

describe Protosite do
  subject { described_class }

  it "has a configuration property" do
    expect(subject.configuration).to be(Protosite::Configuration)
  end

  describe ".configure" do
    it "yields configuration" do
      config = nil
      subject.configure { |c| config = c }
      expect(config).to be(Protosite::Configuration)
    end

    it "sets configured to true" do
      subject.configured = false
      subject.configure { }
      expect(subject.configured).to be_truthy
    end
  end
end
