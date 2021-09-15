class BillingPlan
  PLANS = %w[individual basic business].freeze

  attr_reader :name

  def self.all
    PLANS.map { |plan| new(name: plan) }
  end

  def initialize(name:)
    if !PLANS.include?(name)
      raise PlanNotFound
    end

    @name = name.to_sym
  end

  def has_discount?
    original_price > current_price
  end

  def method_missing(method_name)
    if data[name].has_key?(method_name)
      data[name][method_name]
    else
      super
    end
  end

  def data
    {
      individual: {
        id: "individual",
        display_name: "Individual",
        original_price: 10,
        current_price: 10,
        available_seats: 1,
        messages_limit: 1_000,
        custom_email_addresses: 1,
        premium_support: false,
        payment_link: "https://buy.stripe.com/14k3cM1fCbrm4ve9AB",
      },
      basic: {
        id: "basic",
        display_name: "Basic",
        original_price: 25,
        current_price: 25,
        available_seats: 3,
        messages_limit: 3_000,
        custom_email_addresses: 3,
        premium_support: true,
        payment_link: "https://buy.stripe.com/cN228I5vSfHCd1KcMM",
      },
      business: {
        id: "business",
        display_name: "Business",
        original_price: 100,
        current_price: 100,
        available_seats: 10,
        messages_limit: 10_000,
        custom_email_addresses: 10,
        premium_support: true,
        payment_link: "https://buy.stripe.com/6oE9Ba7E09jee5O002",
      }
    }
  end

  class PlanNotFound < StandardError; end
end
