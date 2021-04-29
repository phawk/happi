class BetaSignupsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :ensure_team!

  def create
    signup = BetaSignup.new(email: email_address)

    if BetaSignup.where(email: email_address).any?
      flash[:error] = "You are already on the list, we’ll be in touch soon!"
      redirect_to root_path
    elsif signup.save
      redirect_to root_path, notice: "Thanks for registering, we’ll be in touch soon!"
    else
      flash[:error] = "Oops, we had a problem, double check your email and try again."
      redirect_to root_path
    end
  end

  private

  def email_address
    params.dig(:beta_signup, :email)&.downcase
  end
end
