require "spec_helper"

describe Protosite::Types::UserType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type("ID!") }
  it { is_expected.to have_field(:name).of_type("String!") }
  it { is_expected.to have_field(:email).of_type("String!") }
  it { is_expected.to have_field(:token).of_type("String") }
  it { is_expected.to have_field(:permissions).of_type("Json") }

  describe "getters" do
    subject { described_class.new(user, current_user: user) }

    let(:user) { create(:user) }

    it "only gives the current user their token" do
      expect(subject.token).to eq user.authentication_token

      subject = described_class.new(user, current_user: create(:user))
      expect(subject.token).to be_nil
    end

    it "only includes permissions that are true (as to not expose permission names to users who don't have them)" do
      user.permissions = { create_page: false, publish_page: true, remove_page: false, update_self: false }
      user.admin = true
      expect(subject.permissions).to eq(
        "publish_page" => true,
        "admin" => true,
      )
    end
  end
end
