class TeamUsersController < ApplicationController
  before_action :set_team_user

  def update
    if @team_user.update(team_user_params)
      redirect_to team_settings_path, notice: "Notification settings saved"
    else
      redirect_to team_settings_path, alert: "Something went wrong, please try again"
    end
  end

  def destroy
    user = @team_user.user
    if user == current_user
      flash[:error] = "You cannot remove yourself"
    else
      @team_user.destroy
      if user.teams.count.zero?
        user.destroy
      end
    end
    redirect_to team_settings_path
  end

  private

  def set_team_user
    @team_user = current_team.team_users.find(params[:id])
  end

  def team_user_params
    params.require(:team_user).permit(:message_notifications)
  end
end
