require "spec_helper"

describe Protosite::Mutations::UpdateCurrentUser do
  subject { described_class }

  let(:accepted_args) { {
    email: "String",
    password: "String",
  } }

  it { is_expected.to accept_arguments(accepted_args) }
  it { is_expected.to be_of_type("Protosite::Types::UserType") }

  describe "resolve" do
    subject { described_class.new(object: nil, context: { current_user: user }) }

    let(:user) { create(:user) }
    let(:args) { {
      email: "email@example.com",
    } }

    it "updates the current user" do
      subject.resolve(args)
      expect(user.reload.email).to eq "email@example.com"
    end

    it "broadcasts the expected events" do
      allow(subject).to receive(:broadcast)
      subject.resolve(args)
      expect(subject).to have_received(:broadcast).with(
        :user_updated,
        user,
        args: { id: user.to_param }
      )
    end
  end
end
