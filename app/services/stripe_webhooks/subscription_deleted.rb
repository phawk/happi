module StripeWebhooks
  class SubscriptionDeleted
    def call(event)
      stripe_sub = event[:data][:object]

      team = Team.find_by(stripe_subscription_id: stripe_sub.id)
      return if team.blank?

      team.update!(subscription_status: "canceled")
    end
  end
end
