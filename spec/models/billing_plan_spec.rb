require "rails_helper"

RSpec.describe BillingPlan, type: :model do
  it "exposes plan information" do
    plan = BillingPlan.new(name: "starter")
    expect(plan.display_name).to eq("Starter")
    expect(plan.original_price).to eq(29)
    expect(plan.current_price).to eq(29)
    expect(plan.currency).to eq("USD")
    expect(plan.symbol).to eq("$")
    expect(plan.available_seats).to eq(2)
    expect(plan.messages_limit).to eq(1000)
    expect(plan.custom_email_addresses).to eq(1)
    expect(plan.premium_support).to eq(false)
    expect(plan.ai_autonomous_bot?).to eq(false)
  end

  it "raises an error when plan cant be found" do
    expect do
      BillingPlan.new(name: "badass")
    end.to raise_error(BillingPlan::PlanNotFound)
  end

  describe "#has_discount?" do
    it "returns true when the plan has a discount running" do
      basic_plan = BillingPlan.new(name: "starter")
      expect(basic_plan.has_discount?).to be(false)
    end
  end

  describe "#select_option" do
    it "returns an option for select dropdown" do
      basic_plan = BillingPlan.new(name: "starter")
      expect(basic_plan.select_option).to eq(["Starter ($29/mo)", "starter"])
    end
  end
end
