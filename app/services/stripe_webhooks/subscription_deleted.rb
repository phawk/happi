module StripeWebhooks
  class SubscriptionDeleted
    def call(event)
      stripe_sub = event[:data][:object]
      team_id = stripe_sub.metadata["happi_team_id"]
      team = Team.find(team_id)
      return if team.blank?

      team.update!(subscription_status: "canceled")

      AdminMailer.notification(
        "Subscription cancelled for #{team.name}",
        "#{team.name} on the #{team.plan} plan has been cancelled."
      ).deliver_later

      true
    end
  end
end
