require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Happi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Set Active::Job backend
    config.active_job.queue_adapter = :sidekiq
    config.active_storage.queues.analysis = :default
    config.active_storage.queues.purge = :default
    config.active_storage.queues.mirror = :default

    config.generators do |g|
      g.skip_routes true
      g.helper false
      g.assets false
      g.test_framework :rspec, fixture: false
      g.helper_specs false
      g.controller_specs false
      g.system_tests false
      g.view_specs false
    end

    config.to_prepare do
      Devise::SessionsController.layout "auth"
      # DeviseInvitable::RegistrationsController.layout "auth"
      # Devise::InvitationsController.layout "auth"
      Devise::RegistrationsController.layout "auth"
      Devise::ConfirmationsController.layout "auth"
      Devise::UnlocksController.layout "auth"
      Devise::PasswordsController.layout "auth"
      Devise::Mailer.layout "mailer"
    end

    # GZip all responses
    config.middleware.use Rack::Deflater

    # View Component Previews
    config.view_component.default_preview_layout = "component_preview"
    config.view_component.preview_paths << "#{Rails.root}/app/components/previews"
  end
end
