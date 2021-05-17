class SettingsController < ApplicationController
  def show; end

  def emails
    @custom_emails = current_team.custom_email_addresses
    @custom_email_address = CustomEmailAddress.new
  end

  def team
    @team_members = current_team.users.to_a
  end

  def canned_responses
    @canned_responses = current_team.canned_responses.order(:created_at)
  end

  def widget; end
end
