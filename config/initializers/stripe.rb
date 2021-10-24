require "stripe_event"

billing_mode = ENV.fetch("BILLING_MODE", "test")

Stripe.api_key = if billing_mode == "live"
  ENV.fetch("STRIPE_LIVE_SECRET_KEY")
else
  ENV.fetch("STRIPE_TEST_SECRET_KEY")
end

StripeEvent.signing_secrets = [
  ENV.fetch("STRIPE_TEST_WEBHOOKS_SECRET"),
  ENV.fetch("STRIPE_LIVE_WEBHOOKS_SECRET"),
  ENV["STRIPE_CLI_WEBHOOKS_SECRET"], # stripe-cli local
].compact

class EventFilter
  def call(event)
    event.api_key = if event.livemode
      ENV.fetch("STRIPE_LIVE_SECRET_KEY")
    else
      ENV.fetch("STRIPE_TEST_SECRET_KEY")
    end
    event
  end
end

StripeEvent.event_filter = EventFilter.new

Rails.application.reloader.to_prepare do
  StripeEvent.configure do |events|
    # events.subscribe 'checkout.session.completed', StripeWebhooks::CheckoutSessionCompleted.new
    # events.subscribe 'customer.subscription.created', StripeWebhooks::SubscriptionUpdated.new
    events.subscribe "customer.subscription.updated", StripeWebhooks::SubscriptionUpdated.new
    events.subscribe "customer.subscription.deleted", StripeWebhooks::SubscriptionDeleted.new
    # events.subscribe 'invoice.created', StripeWebhooks::InvoiceCreated.new
    # events.subscribe 'invoice.payment_succeeded', StripeWebhooks::InvoicePaymentSucceeded.new
    # events.subscribe 'invoice.payment_failed', StripeWebhooks::InvoicePaymentFailed.new
  end
end
