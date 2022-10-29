class TeamUsersController < ApplicationController
  def update
    @team_user = current_team.team_users.find(params[:id])

    if @team_user.update(team_user_params)
      redirect_to team_settings_path, notice: "Notification settings saved"
    else
      redirect_to team_settings_path, alert: "Something went wrong, please try again"
    end
  end

  private

  def team_user_params
    params.require(:team_user).permit(:message_notifications)
  end
end
