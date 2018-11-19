require "spec_helper"

describe ProtositeChannel do
  subject { described_class.new(connection, {}) }

  let(:connection) { double(identifiers: [:current_user], current_user: user) }
  let(:user) { create(:user) }

  before do
    allow(subject).to receive(:transmit).with(anything)
  end

  it "executes the query and transmits the results" do
    options = { current_user: user, channel: subject }
    result = double(context: {}, subscription?: false, to_h: { data: "_result_" })
    expect(Protosite::Schema).to receive(:execute).with({ foo: "bar" }, options).and_return(result)

    subject.subscribed
    subject.execute(foo: "bar")
    expect(subject).to have_received(:transmit).with(result: { data: "_result_" }, more: false)
  end

  it "handles subscription behaviors" do
    options = { current_user: user, channel: subject }
    result = double(context: { subscription_id: 666 }, subscription?: true, to_h: { data: "_result_" })
    expect(Protosite::Schema).to receive(:execute).with({ foo: "bar" }, options).and_return(result)

    subject.subscribed
    subject.execute(foo: "bar")
    expect(subject).to have_received(:transmit).with(result: { data: nil }, more: true)

    expect(Protosite::Schema.subscriptions).to receive(:delete_subscription).with(666)
    subject.unsubscribed
  end
end
