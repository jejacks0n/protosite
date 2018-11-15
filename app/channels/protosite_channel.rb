class ProtositeChannel < Protosite.configuration.parent_channel.constantize
  def subscribed
    @subscription_ids = []
  end

  def execute(data)
    result = Protosite::Schema.execute(data, current_user: current_user, channel: self)
    @subscription_ids << result.context[:subscription_id] if result.context[:subscription_id]
    transmit result: result.subscription? ? { data: nil } : result.to_h, more: result.subscription?
  end

  def unsubscribed
    @subscription_ids.each { |sid| Protosite::Schema.subscriptions.delete_subscription(sid) }
  end
end
