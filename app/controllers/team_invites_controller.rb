class TeamInvitesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :ensure_team!
  layout "auth"

  def show
    @team = Team.find_by!(invite_code: params[:id])
    @invite = User.new
  end

  def create
    @invite = User.new
  end

  private

  def create_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
