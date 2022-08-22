if Rails.env.production?
  Rails.application.config.middleware.use ExceptionNotification::Rack,
    ignore_exceptions: ["ActionController::InvalidAuthenticityToken"] + ExceptionNotifier.ignored_exceptions,
    email: {
      email_prefix: "[HAPPI] ",
      sender_address: %{"Happi Team" <yo@happi.team>},
      exception_recipients: %w{yo@happi.team},
    }
end
