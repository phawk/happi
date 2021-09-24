Sentry.init do |config|
  config.dsn = "https://ad42d55a0552413692766efa1126b7d4@o121912.ingest.sentry.io/5978179"
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set tracesSampleRate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production
  config.traces_sample_rate = 0.5
  # or
  config.traces_sampler = lambda do |_context|
    true
  end
  config.enabled_environments = %i[production]
  config.excluded_exceptions += %w[
    ActionController::RoutingError
    ActiveRecord::RecordNotFound
    Stripe::CardError
    OpenSSL::SSL::SSLError
  ]
end
