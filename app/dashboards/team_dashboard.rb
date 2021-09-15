require "administrate/base_dashboard"

class TeamDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    users: Field::HasMany,
    customers: Field::HasMany,
    message_threads: Field::HasMany,
    custom_email_addresses: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    plan: Field::Select.with_options(
      collection: BillingPlan::PLANS
    ),
    mail_hash: Field::String,
    verified_at: Field::DateTime,
    invite_code: Field::String,
    whitelabel: Field::Boolean,
    available_seats: Field::Number,
    messages_limit: Field::Number,
    messages_used_this_month: Field::Number,
    subscription_status: Field::Select.with_options(
      collection: Team::SUBSCRIPTION_STATES
    ),
    stripe_customer_id: Field::String,
    stripe_subscription_id: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    name
    plan
    subscription_status
    verified_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    plan
    subscription_status
    mail_hash
    verified_at
    invite_code
    whitelabel
    available_seats
    messages_used_this_month
    messages_limit
    stripe_customer_id
    stripe_subscription_id
    users
    custom_email_addresses
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
    plan
    subscription_status
    mail_hash
    verified_at
    invite_code
    whitelabel
    available_seats
    messages_limit
    stripe_customer_id
    stripe_subscription_id
    users
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how teams are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(team)
    team.name
  end
end
