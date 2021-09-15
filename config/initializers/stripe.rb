require "stripe_event"

billing_mode = ENV.fetch("BILLING_MODE", "test")

if billing_mode == "live"
  Stripe.api_key = Rails.application.credentials.stripe[:live_secret_key]
else
  Stripe.api_key = Rails.application.credentials.stripe[:test_secret_key]
end

StripeEvent.signing_secrets = [
  Rails.application.credentials.stripe[:test_webhooks_secret],
  Rails.application.credentials.stripe[:live_webhooks_secret],
  "whsec_ZzjKbxPTxLMqxdvuPVzbdgq9661etDS8" # stripe-cli local
]

class EventFilter
  def call(event)
    if event.livemode
      event.api_key = stripe_config[:live_secret_key]
    else
      event.api_key = stripe_config[:test_secret_key]
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
    events.subscribe 'customer.subscription.updated', StripeWebhooks::SubscriptionUpdated.new
    events.subscribe 'customer.subscription.deleted', StripeWebhooks::SubscriptionDeleted.new
    # events.subscribe 'invoice.created', StripeWebhooks::InvoiceCreated.new
    # events.subscribe 'invoice.payment_succeeded', StripeWebhooks::InvoicePaymentSucceeded.new
    # events.subscribe 'invoice.payment_failed', StripeWebhooks::InvoicePaymentFailed.new
  end
end
