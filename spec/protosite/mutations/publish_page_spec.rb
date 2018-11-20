require "spec_helper"

describe Protosite::Mutations::PublishPage do
  subject { described_class }

  let(:accepted_args) { {
    id: "ID!",
  } }

  it { is_expected.to accept_arguments(accepted_args) }
  it { is_expected.to be_of_type("Protosite::Types::PageType") }

  describe "resolve" do
    subject { described_class.new(object: nil, context: { current_user: user }) }

    let(:user) { create(:user) }
    let(:page) { create(:page, versions: [{ title: "New pending title" }]) }
    let(:args) { {
      id: page.id,
    } }

    it "requires authorization" do
      user.permissions = { publish_page: false }
      expect { subject.resolve(args) }.to raise_error(GraphQL::ExecutionError, "unauthorized")
    end

    it "publishes a page" do
      subject.resolve(args)
      expect(page.reload.published?).to be_truthy
      expect(page.data["title"]).to eq "New pending title"
    end

    it "broadcasts the expected events" do
      allow(subject).to receive(:broadcast)
      subject.resolve(args)
      expect(subject).to have_received(:broadcast).with(:page_updated, page)
    end
  end
end
