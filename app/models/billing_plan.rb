class BillingPlan
  PLANS = %w[free individual basic business].freeze

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
      "#{display_name} (£#{current_price}/mo)",
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
        visible: true,
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
        live_stripe_price_id: "price_1JZwXvF0UsUPXe7UNwhTuAMw",
        test_stripe_price_id: "price_1JZyyPF0UsUPXe7U8XePod43",
        visible: true,
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
        live_stripe_price_id: "price_1JZvyHF0UsUPXe7U6jDbjSMT",
        test_stripe_price_id: "price_1JZyzYF0UsUPXe7Ul2U3fW7N",
        visible: true,
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
        live_stripe_price_id: "price_1JZwYCF0UsUPXe7UqNfzclnX",
        test_stripe_price_id: "price_1JZyzmF0UsUPXe7UrJbBVrva",
        visible: false,
        initial_subscription_state: "pending",
      },
    }
  end

  class PlanNotFound < StandardError; end
end
