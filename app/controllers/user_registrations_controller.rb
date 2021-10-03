class UserRegistrationsController < Devise::RegistrationsController
  def new
    session[:signup_plan] = params[:plan] if params[:plan].present?
    super
  end

  def create
    build_resource(sign_up_params)

    if verify_recaptcha(model: resource)
      super
    else
      render :new
    end
  end
end
