require "spec_helper"

describe Protosite::Mutations::UpdatePage do
  subject { described_class }

  let(:accepted_args) { {
    id: "ID!",
    data: "Json!",
  } }

  it { is_expected.to accept_arguments(accepted_args) }
  it { is_expected.to be_of_type("Protosite::Types::PageType") }

  describe "resolve" do
    subject { described_class.new(object: nil, context: { current_user: user }) }

    let(:user) { create(:user) }
    let(:page) { create(:page) }
    let(:args) { {
      id: page.id,
      data: { title: "Updated title" }.to_json
    } }

    it "updates the page" do
      subject.resolve(args)
      expect(page.reload.versions).to eq [{ "title" => "Updated title" }]
    end

    it "broadcasts the expected events" do
      allow(subject).to receive(:broadcast)
      subject.resolve(args)
      expect(subject).to have_received(:broadcast).with(
        :page_updated,
        page,
        args: { id: page.to_param }
      )
    end
  end
end
