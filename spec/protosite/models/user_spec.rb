require "spec_helper"

describe Protosite::User, type: :model do
  subject { build(:user) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }

  it "generates an authentication token" do
    expect(subject.authentication_token).to be_nil
    subject.save!
    expect(subject.authentication_token).to_not be_nil
  end

  it "has permission attributes" do
    expect(subject.permissions.create_page).to be_truthy
    expect(subject.permissions.publish_page).to be_truthy
    expect(subject.permissions.remove_page).to be_truthy

    subject.permissions.create_page = false
    expect(subject.permissions.create_page).to be_falsey
  end

  describe "password validations" do
    context "on a new user" do
      it "should not be valid without a password" do
        user = build(:user, password: nil, password_confirmation: nil)
        expect(user).to_not be_valid

        user = build(:user, password: "agoodpassword", password_confirmation: "agoodpassword")
        expect(user).to be_valid
      end

      it "should not be valid with a confirmation mismatch" do
        user = build(:user, password: "short", password_confirmation: "long")
        expect(user).to_not be_valid
      end
    end

    context "on an existing user" do
      let!(:user) { create(:user) }

      it "should be valid with no changes" do
        expect(user).to be_valid
      end

      it "should not be valid with an empty password" do
        user.password = user.password_confirmation = ""
        expect(user).to_not be_valid
      end

      it "should be valid with a new (valid) password" do
        user.password = user.password_confirmation = "new password"
        expect(user).to be_valid
      end
    end
  end
end
