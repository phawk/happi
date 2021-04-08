class TeamsController < ApplicationController
  skip_before_action :ensure_team!

  layout "auth"

  def index
    @teams = current_user.teams
  end

  def change
    team = current_user.teams.find(params[:id])
    current_user.update(team: team)
    redirect_to root_path, notice: t(".switched_to", name: team.name)
  end

  def new
    @team = Team.new
  end

  def create
    @team = current_user.teams.new(team_params)

    if @team.save
      @team.add_user(current_user, set_active_team: true)

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
