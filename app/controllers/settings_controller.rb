class SettingsController < ApplicationController
  def show
    @custom_emails = current_team.custom_email_addresses
    @custom_email_address = CustomEmailAddress.new
    @team_members = current_team.users.to_a
  end
end
