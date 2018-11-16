require "spec_helper"

describe Protosite::Schema do
  describe "executing" do
    it "executes with the expected options" do
      context = { foo: "bar" }
      expect(GraphQL::Schema).to receive(:execute).with(
        query: "_q_",
        variables: { "foo" => "bar" },
        operation_name: "_op_",
        context: context
      )
      described_class.execute({ "query" => "_q_", "variables" => %{{"foo": "bar"}}, "operationName" => "_op_" }, context)
    end
  end

  describe "broadcasting" do
    before do
      @mock = double(trigger: nil)
      allow(described_class).to receive(:subscriptions).and_return(@mock)
    end

    it "triggers the expected event with the provided resource and args" do
      described_class.broadcast(:event, { resource: true }, { args: { args: true } })
      expect(@mock).to have_received(:trigger).with(:event, { args: true }, { resource: true })
    end

    it "optionally triggers a notification event if a message was provided" do
      described_class.broadcast(nil, nil, message: "_message_")
      expect(@mock).to have_received(:trigger).with(:notification, {}, { message: "_message_" })
    end
  end
end
