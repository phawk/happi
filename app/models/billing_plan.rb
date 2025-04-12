class BillingPlan
  PLANS = %w[free individual basic business starter growth scale].freeze

  attr_reader :name

  def self.all
    PLANS.map { |plan| new(name: plan) }
  end

  def self.visible
    all.select(&:visible)
  end

  def self.paid_plans
    all.select { |plan| plan.current_price > 0 }
  end

  def initialize(name:)
    unless PLANS.include?(name)
      raise PlanNotFound
    end

    @name = name.to_sym
  end

  def has_discount?
    original_price > current_price
  end

  def method_missing(method_name)
    if data[name].key?(method_name)
      data[name][method_name]
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    data[name].key?(method_name) || super
  end

  def select_option
    [
      "#{display_name} ($#{current_price}/mo)",
      id,
    ]
  end

  def data
    {
      free: {
        id: "free",
        display_name: "Free",
        description: "Perfect for early-stage startups.",
        original_price: 0,
        current_price: 0,
        available_seats: 1,
        messages_limit: 100,
        custom_email_addresses: 1,
        premium_support: false,
        live_stripe_price_id: nil,
        test_stripe_price_id: nil,
        visible: false,
        initial_subscription_state: "trialing",
      },
      individual: {
        id: "individual",
        display_name: "Individual",
        description: "Billed monthly, no commitments, cancel anytime!",
        original_price: 10,
        current_price: 10,
        available_seats: 1,
        messages_limit: 1_000,
        custom_email_addresses: 1,
        premium_support: false,
        live_stripe_price_id: "price_1NMqquLkfrm0pujLBJOGvXfj",
        test_stripe_price_id: "price_1NMqpBLkfrm0pujL7odofgZC",
        visible: false,
        initial_subscription_state: "pending",
      },
      basic: {
        id: "basic",
        display_name: "Basic",
        description: "Billed monthly, no commitments, cancel anytime!",
        original_price: 25,
        current_price: 25,
        available_seats: 3,
        messages_limit: 3_000,
        custom_email_addresses: 3,
        premium_support: true,
        live_stripe_price_id: "price_1NMqqBLkfrm0pujLT6u5D4sD",
        test_stripe_price_id: "price_1NMqprLkfrm0pujLfSFZknRW",
        visible: false,
        initial_subscription_state: "pending",
      },
      business: {
        id: "business",
        display_name: "Business",
        description: "Billed monthly, no commitments, cancel anytime!",
        original_price: 100,
        current_price: 100,
        available_seats: 10,
        messages_limit: 10_000,
        custom_email_addresses: 10,
        premium_support: true,
        live_stripe_price_id: "price_1NMqqYLkfrm0pujLsfl18rUg",
        test_stripe_price_id: "price_1NMqqWLkfrm0pujLFh6UQLhK",
        visible: false,
        initial_subscription_state: "pending",
      },
      starter: {
        id: "starter",
        display_name: "Starter",
        description: "Billed monthly, no commitments, cancel anytime!",
        original_price: 29,
        current_price: 29,
        available_seats: 1,
        messages_limit: 1_000,
        custom_email_addresses: 1,
        premium_support: false,
        live_stripe_price_id: "price_1RCyrrLkfrm0pujLGI2XYhfN",
        test_stripe_price_id: "price_1RCyuWLkfrm0pujLStoKnnz0",
        visible: true,
        initial_subscription_state: "pending",
      },
      growth: {
        id: "growth",
        display_name: "Growth",
        description: "Billed monthly, no commitments, cancel anytime!",
        original_price: 79,
        current_price: 79,
        available_seats: 3,
        messages_limit: 3_000,
        custom_email_addresses: 3,
        premium_support: false,
        live_stripe_price_id: "price_1RCysYLkfrm0pujLohUkEqmn",
        test_stripe_price_id: "price_1RCyuzLkfrm0pujL1GypJMYx",
        visible: true,
        initial_subscription_state: "pending",
      },
      scale: {
        id: "scale",
        display_name: "Scale",
        description: "Billed monthly, no commitments, cancel anytime!",
        original_price: 149,
        current_price: 149,
        available_seats: 5,
        messages_limit: 10_000,
        custom_email_addresses: 10,
        premium_support: true,
        live_stripe_price_id: "price_1RCyu0Lkfrm0pujLLM4kDxwu",
        test_stripe_price_id: "price_1RCyvNLkfrm0pujL54iiM7a0",
        visible: true,
        initial_subscription_state: "pending",
      },
    }
  end

  class PlanNotFound < StandardError; end
end
