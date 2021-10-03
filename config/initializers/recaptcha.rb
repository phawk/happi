Recaptcha.configure do |config|
  config.site_key = Rails.application.credentials.google_recaptcha_key
  config.secret_key = Rails.application.credentials.google_recaptcha_secret
  # config.skip_verify_env << "development"
end
