module Billing
  class SubscriptionsController < ApplicationController
    skip_before_action :authenticate_user!, only: :success

    def show
      @plans = BillingPlan.visible_paid_plans
    end

    def create
      plan = BillingPlan.new(name: params[:plan])
      current_team.change_plan(plan)
      checkout = create_checkout(with_plan: plan)
      redirect_to checkout.url, allow_other_host: true
    end

    def manage
      portal_url = BillingService.create_portal_link(
        user: current_user,
        team: current_team,
        return_url: billing_settings_url
      )
      redirect_to portal_url, allow_other_host: true
    end

    def success
      render layout: "auth"
    end
  end
end
