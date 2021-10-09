class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :ensure_team!
  before_action :set_pricing_plans, only: %i[home pricing]
  layout "marketing"

  def home; end

  def pricing; end

  def terms; end

  def privacy; end

  def security; end

  def changelog
    @changelog = if params[:preview] && current_user&.role?(:admin)
      Changelog.ordered
    else
      Changelog.published.ordered
    end
  end

  private

  def set_pricing_plans
    @plans = BillingPlan.visible
  end
end
