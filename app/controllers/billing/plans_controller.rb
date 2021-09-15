module Billing
  class PlansController < ApplicationController
    def index
      @plans = BillingPlan.all
    end
  end
end
