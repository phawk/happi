class TeamInvitesController < ApplicationController
  skip_before_action :authenticate_user!, except: :update
  skip_before_action :ensure_team!
  before_action :set_team
  before_action :ensure_available_seat, only: %i[create update]
  layout "auth"

  def new
    @invite = User.new
  end

  def create
    @invite = User.new(create_params)

    if @invite.save
      @team.add_user(@invite, set_active_team: true)
      sign_in @invite
      redirect_to message_threads_path, notice: "You have signed up successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @team.add_user(current_user, set_active_team: true)
    redirect_to message_threads_path, notice: "You are now a member of #{@team.name}"
  end

  private

  def ensure_available_seat
    unless @team.has_available_seat?
      flash[:alert] = "Your team has no available seats, contact support to request more."
      return redirect_to root_url
    end
  end

  def set_team
    @team = Team.find_by!(invite_code: params[:code])
  end

  def create_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      :terms_and_conditions
    )
  end
end
