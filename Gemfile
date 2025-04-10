source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.4"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "7.2.0"
# Use postgresql as the database for Active Record
gem "pg"
# Use Puma as the app server
gem "puma"
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
# Full text search
gem "pg_search"

# Use Active Storage variant
gem "image_processing", "~> 1.12"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

gem "devise"
gem "devise_masquerade"
gem "view_component"
gem "lookbook"
gem "name_of_person"
gem "chroma"
gem "aws-sdk-s3", require: false
gem "postmark-rails"
gem "roadie-rails"
gem "sidekiq", "~> 7.0"
gem "email_reply_parser"
gem "metamagic"
gem "country_select"
gem "administrate"
gem "jwt"
gem "rack-cors", require: "rack/cors"
gem "rack-attack"
gem "stripe", "~> 5.38"
gem "stripe_event"
gem "attr_json"
gem "recaptcha"
gem "exception_notification"
gem "slack-notifier", "~> 2.4"

# Code style guide
gem "rubocop-rails", require: false
gem "rubocop-rspec", require: false
gem "rubocop-shopify", require: false

group :development, :test do
  gem "rspec-rails"
  gem "dotenv-rails"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 4.1.0"
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  # gem 'rack-mini-profiler', '~> 2.0'
  gem "rexml"
  gem "letter_opener_web"
end

group :test do
  gem "shoulda-matchers", "~> 4.0", require: false
  gem "capybara"
  gem "selenium-webdriver"
  gem "stripe-ruby-mock", "~> 4.0.0", require: "stripe_mock"
  gem "simplecov", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "matrix", "~> 0.4.2"

gem "csv", "~> 3.3"

gem "ruby-openai"

gem "langchainrb"

# Dry.rb
gem "dry-initializer", "~> 3.1"
gem "dry-monads"
gem "dry-operation"

gem "active_storage_validations", "~> 1.1"

# File processing for embeddings
gem "pdf-reader"
gem "docx"
gem "power_point_pptx"
gem "roo"
gem "roo-xls"
