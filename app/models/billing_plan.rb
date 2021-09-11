class BillingPlan
  PLANS = %w[basic beta].freeze

  attr_reader :name

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
      basic: {
        display_name: "Basic",
        original_price: 25,
        current_price: 25
      },
      beta: {
        display_name: "Beta",
        original_price: 25,
        current_price: 0
      }
    }
  end

  class PlanNotFound < StandardError; end
end
