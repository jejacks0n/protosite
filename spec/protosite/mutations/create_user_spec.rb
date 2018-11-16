require "spec_helper"

describe Protosite::Mutations::CreateUser do
  subject { described_class }

  let(:accepted_args) { {
    name: "String!",
    email: "String!",
    password: "String!",
  } }

  it { is_expected.to accept_arguments(accepted_args) }
  it { is_expected.to be_of_type("Protosite::Types::UserType") }

  describe "resolve" do
    subject { described_class.new(object: nil, context: { current_user: user }) }

    let(:user) { create(:user) }
    let(:args) { {
      name: "Sterling Archer",
      email: "agent@isis.com",
      password: "password",
    } }

    it "creates a user" do
      result = subject.resolve(args)
      expect(result).to be_a Protosite::User
      expect(result.name).to eq "Sterling Archer"
    end

    it "broadcasts the expected events" do
      allow(subject).to receive(:broadcast)
      user = subject.resolve(args)
      expect(subject).to have_received(:broadcast).with(
        :user_created,
        user
      )
    end
  end
end
