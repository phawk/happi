class UserRegistrationsController < Devise::RegistrationsController
  def new
    session[:signup_plan] = params[:plan] if params[:plan].present?
    super
  end
end
