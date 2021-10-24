Recaptcha.configure do |config|
  config.site_key = ENV.fetch("GOOGLE_RECAPTCHA_KEY")
  config.secret_key = ENV.fetch("GOOGLE_RECAPTCHA_SECRET")
  # config.skip_verify_env << "development"
end
