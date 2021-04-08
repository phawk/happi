class TeamInvitesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :ensure_team!
  before_action :set_team
  layout "auth"

  def new
    @invite = User.new
  end

  def create
    @invite = User.new(create_params)

    if @invite.save
      @team.users << @invite
      @invite.update(team: @team)
      sign_in @invite
      redirect_to message_threads_path, notice: "You have signed up successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_team
    @team = Team.find_by!(invite_code: params[:code])
  end

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
