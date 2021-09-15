module StripeWebhooks
  class SubscriptionUpdated
    def call(event)
      stripe_sub = event[:data][:object]

      team = Team.find_by(stripe_subscription_id: stripe_sub.id)
      return if team.blank?

      team.subscription_status = stripe_sub.status
      team.subscription_status = "canceled" if stripe_sub.cancel_at_period_end

      team.save!
    end
  end
end
