require "stripe_event"

billing_mode = ENV.fetch("BILLING_MODE", "test")

Stripe.api_key = if billing_mode == "live"
  Rails.application.credentials.stripe[:live_secret_key]
else
  Rails.application.credentials.stripe[:test_secret_key]
end

StripeEvent.signing_secrets = [
  Rails.application.credentials.stripe[:test_webhooks_secret],
  Rails.application.credentials.stripe[:live_webhooks_secret],
  "whsec_ZzjKbxPTxLMqxdvuPVzbdgq9661etDS8", # stripe-cli local
]

class EventFilter
  def call(event)
    event.api_key = if event.livemode
      stripe_config[:live_secret_key]
    else
      stripe_config[:test_secret_key]
    end
    event
  end

  def stripe_config
    Rails.application.credentials.stripe
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
