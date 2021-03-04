class TeamsController < ApplicationController
  skip_before_action :ensure_team!

  layout "auth"

  def new
    @team = Team.new
  end

  def create
    @team = current_user.teams.new(team_params)

    if @team.save
      current_user.update(team: @team)

      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
