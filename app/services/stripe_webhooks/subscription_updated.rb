module StripeWebhooks
  class SubscriptionUpdated
    def call(event)
      stripe_sub = event[:data][:object]
      team_id = stripe_sub.metadata["happi_team_id"]
      team = Team.find(team_id)
      return if team.blank?

      team.stripe_subscription_id = stripe_sub.id
      team.subscription_status = stripe_sub.status
      team.subscription_status = "canceled" if stripe_sub.cancel_at_period_end
      if stripe_sub.status == "active" && !team.verified?
        team.verified_at = Time.current
      end

      team.save!
    end
  end
end
