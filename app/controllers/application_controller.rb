class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :ensure_team!

  protected

  def current_team
    current_user.team
  end
  helper_method :current_team

  def ensure_team!
    unless current_user.team.present?
      redirect_to new_team_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name avatar])
  end
end
