require "sidekiq/web"

# Don't configure redis in testing
unless Rails.env.test?
  redis_settings = {
    url: ENV.fetch("REDIS_URL", ENV.fetch("REDISCLOUD_URL", "redis://127.0.0.1:6379/4")),
    network_timeout: 3,
  }

  Sidekiq.configure_server do |config|
    config.redis = redis_settings
  end

  Sidekiq.configure_client do |config|
    config.redis = redis_settings
  end
end
