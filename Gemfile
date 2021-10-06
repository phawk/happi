source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 6.1.3"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use Puma as the app server
gem "puma", "~> 5.3"
# CSS and JS bundling
gem "cssbundling-rails"
gem "jsbundling-rails"
# Hotwire, turbo, stimulus
gem "hotwire-rails"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"
# Analytics and events
gem "ahoy_matey"
# Business intelligence dashboards
gem "blazer"

# Use Active Storage variant
gem "image_processing", "~> 1.2"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

gem "devise"
gem "devise_masquerade"
gem "view_component", require: "view_component/engine"
gem "name_of_person"
gem "chroma"
gem "aws-sdk-s3", require: false
gem "postmark-rails"
gem "roadie-rails"
gem "sidekiq"
gem "email_reply_parser"
gem "metamagic"
gem "country_select"
gem "administrate"
gem "jwt"
gem "rack-cors", require: "rack/cors"
gem "rack-attack"
gem "strong_migrations"
gem "stripe", "~> 5.38"
gem "stripe_event"
gem "attr_json"
gem "recaptcha"

# Error/performance monitoring
gem "sentry-ruby"
gem "sentry-rails"
gem "sentry-sidekiq"

# Code style guide
gem "rubocop-rails", require: false
gem "rubocop-rspec", require: false
gem "rubocop-shopify", require: false

group :development, :test do
  gem "rspec-rails", "~> 4.0.2"
  gem "dotenv-rails"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  # gem 'rack-mini-profiler', '~> 2.0'
  gem "listen", "~> 3.3"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"

  gem "rexml"
  gem "letter_opener_web"
end

group :test do
  gem "shoulda-matchers", "~> 4.0", require: false
  gem "capybara"
  gem "selenium-webdriver"
  gem "stripe-ruby-mock", "~> 3.0.1", require: "stripe_mock"
  gem "simplecov", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
