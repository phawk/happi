require "rails_helper"

RSpec.describe BillingPlan, type: :model do
  it "exposes plan information" do
    plan = BillingPlan.new(name: "basic")
    expect(plan.display_name).to eq("Basic")
    expect(plan.original_price).to eq(25)
    expect(plan.current_price).to eq(25)
  end

  it "raises an error when plan cant be found" do
    expect do
      BillingPlan.new(name: "badass")
    end.to raise_error(BillingPlan::PlanNotFound)
  end

  describe "#has_discount?" do
    it "returns true when the plan has a discount running" do
      basic_plan = BillingPlan.new(name: "basic")
      expect(basic_plan.has_discount?).to be(false)
    end
  end

  describe "#select_option" do
    it "returns an option for select dropdown" do
      basic_plan = BillingPlan.new(name: "basic")
      expect(basic_plan.select_option).to eq(["Basic (£25/mo)", "basic"])
    end
  end
end
