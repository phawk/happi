billing_mode = ENV.fetch("BILLING_MODE", "test")

if billing_mode == "live"
  Stripe.api_key = Rails.application.credentials.stripe[:live_secret_key]
else
  Stripe.api_key = Rails.application.credentials.stripe[:test_secret_key]
end
