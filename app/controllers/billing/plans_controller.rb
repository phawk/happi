module Billing
  class PlansController < ApplicationController
    skip_before_action :authenticate_user!, only: :success

    def index
      @plans = BillingPlan.all
    end

    def success
      render layout: "auth"
    end
  end
end
