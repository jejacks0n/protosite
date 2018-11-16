require "spec_helper"

describe Protosite::TokenStrategy do
  subject { described_class.new({}) }

  before do
    allow(subject).to receive(:authentication_token).and_return("abc123")
  end

  it "is valid if there's an authentication token present in params" do
    expect(subject.valid?).to be_truthy

    allow(subject).to receive(:authentication_token).and_return(nil)
    expect(subject.valid?).to be_falsey
  end

  it "authenticates using the provided authentication token" do
    expect(subject.authenticate!).to eq :failure

    create(:user, authentication_token: "abc123")
    expect(subject.authenticate!).to eq :success
  end
end

describe Protosite::BasicStrategy do
  subject { described_class.new({}) }

  let(:mock) { double(provided?: true, basic?: true, credentials: ["agent@isis.com", "password"]) }

  before do
    allow(subject).to receive(:auth).and_return(mock)
  end

  it "is valid if there were basic auth credentials provided" do
    expect(subject.valid?).to be_truthy

    allow(subject).to receive(:auth).and_return(double(provided?: false))
    expect(subject.valid?).to be_falsey

    allow(subject).to receive(:auth).and_return(double(provided?: true, basic?: false))
    expect(subject.valid?).to be_falsey

    allow(subject).to receive(:auth).and_return(double(provided?: true, basic?: true, credentials: nil))
    expect(subject.valid?).to be_falsey
  end

  it "authenticates using the user provided email and password" do
    expect(subject.authenticate!).to eq :failure

    user = create(:user, email: "agent@isis.com", password: "password")
    expect(subject.authenticate!).to eq :success

    user.update!(password: "not_password")
    expect(subject.authenticate!).to eq :failure

    create(:user, email: "secret.agent@isis.com", password: "password")
    expect(subject.authenticate!).to eq :failure
  end
end
