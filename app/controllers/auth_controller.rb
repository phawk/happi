class AuthController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :ensure_team!
  skip_after_action :track_page_view

  def check
    if user_signed_in?
      render json: { signed_in: true, first_name: current_user.first_name }
    else
      render json: { signed_in: false }
    end
  end
end
