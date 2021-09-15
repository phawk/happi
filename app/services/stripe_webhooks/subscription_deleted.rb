module StripeWebhooks
  class SubscriptionDeleted
    def call(event)
      stripe_sub = event[:data][:object]
      team_id = stripe_sub.metadata["happi_team_id"]
      team = Team.find_by!(id: team_id)
      return if team.blank?

      team.update!(subscription_status: "canceled")
    end
  end
end
