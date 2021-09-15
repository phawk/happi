module Billing
  class SubscriptionsController < ApplicationController
    skip_before_action :authenticate_user!, only: :success

    def show
      @plans = BillingPlan.all
    end

    def create
      plan = BillingPlan.new(name: params[:plan])
      current_team.update!(plan: plan.id, subscription_status: "pending")
      checkout = BillingService.create_checkout(
        plan_id: plan.test_stripe_price_id,
        user: current_user,
        team: current_team,
        success_url: billing_success_url,
        cancel_url: billing_subscriptions_url,
      )
      redirect_to checkout.url
    end

    def success
      render layout: "auth"
    end
  end
end
