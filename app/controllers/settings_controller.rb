class SettingsController < ApplicationController
  def show; end

  def emails
    @custom_emails = current_team.custom_email_addresses
    @custom_email_address = CustomEmailAddress.new
  end

  def team
    @team_members = current_team.team_users.includes(:user).to_a
  end

  def canned_responses
    @canned_responses = current_team.canned_responses.order(:created_at)
  end

  def widget; end

  def billing
    @plan = BillingPlan.new(name: current_team.plan)
    @seats_used = current_team.users.count
    @available_seats = current_team.available_seats
    @messages_used = current_team.messages_used_this_month
    @messages_limit = current_team.messages_limit
  end

  def blocked_domains
    @blocked_domains = current_team.blocked_domains.order(:domain)
  end

  def spam
    # No specific data needs to be loaded here, the form will use current_team
  end

  def spam_update
    if current_team.update(team_params)
      redirect_to spam_settings_path, notice: t(".update_success")
    else
      # Determine which settings page had the error based on submitted params?
      # For now, just render the spam page again if it fails.
      flash.now[:alert] = t(".update_failed")
      render :spam # Re-render the spam form with errors
    end
  end

  private

  def team_params
    params.require(:team).permit(:spam_threshold, :spam_prompt)
  end
end
