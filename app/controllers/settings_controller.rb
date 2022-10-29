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
end
