require "spec_helper"

describe Protosite::Mutations::CreatePage do
  subject { described_class }

  let(:accepted_args) { {
    data: "Json!",
  } }

  it { is_expected.to accept_arguments(accepted_args) }
  it { is_expected.to be_of_type("Protosite::Types::PageType") }

  describe "resolve" do
    subject { described_class.new(object: nil, context: { current_user: user }) }

    let(:user) { create(:user) }
    let(:args) { {
      data: { title: "New Title" },
    } }

    it "requires authentication" do
      subject = described_class.new(object: nil, context: {})
      expect { subject.resolve(args) }.to raise_error(GraphQL::ExecutionError, "unauthenticated")
    end

    it "requires authorization" do
      user.permissions = { create_page: false }
      expect { subject.resolve(args) }.to raise_error(GraphQL::ExecutionError, "unauthorized")
    end

    it "creates a page" do
      result = subject.resolve(args)
      expect(result).to be_a Protosite::Page
      expect(result.slug).to eq "new-title"
    end

    it "broadcasts the expected events" do
      allow(subject).to receive(:broadcast)
      page = subject.resolve(args)
      expect(subject).to have_received(:broadcast).with(:page_created, page)
    end
  end
end
