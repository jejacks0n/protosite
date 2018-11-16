require "spec_helper"

describe Protosite::Types::PageType do
  subject { described_class }

  it { is_expected.to have_field(:id).of_type("ID!") }
  it { is_expected.to have_field(:slug).of_type("String!") }
  it { is_expected.to have_field(:sort).of_type("String!") }
  it { is_expected.to have_field(:data).of_type("Json!") }
  it { is_expected.to have_field(:versions).of_type("[Json!]!") }
  it { is_expected.to have_field(:parent).of_type("Page") }
  it { is_expected.to have_field(:pages).of_type("[Page!]") }

  describe "getters" do
    subject { described_class.new(page, current_user: user) }

    let(:user) { create(:user) }
    let(:page) { create(:page, parent_id: parent.id) }
    let(:parent) { create(:page) }

    it "finds the parent by data or association" do
      expect(subject.parent).to eq parent

      other_parent = create(:page)
      page.data = { parent_id: other_parent.id }

      subject = described_class.new(page, current_user: user)
      expect(subject.parent).to eq other_parent
    end
  end
end
