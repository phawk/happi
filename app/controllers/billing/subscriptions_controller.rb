module Billing
  class SubscriptionsController < ApplicationController
    skip_before_action :authenticate_user!, only: :success

    def show
      @plans = BillingPlan.all
    end

    def success
      render layout: "auth"
    end
  end
end
