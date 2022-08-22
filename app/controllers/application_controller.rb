class ApplicationController < ActionController::Base
  include ActionView::RecordIdentifier # dom_id(record)

  before_action :masquerade_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :ensure_team!
  before_action :prepare_exception_notifier
  around_action :configure_time_zone, if: :current_user
  after_action :track_page_view

  rescue_from ActionView::MissingTemplate, ActiveRecord::RecordNotFound do |exception|
    raise exception if Rails.env.development?

    halt_not_found!
  end

  rescue_from ActionController::UnknownFormat do |exception|
    raise exception if Rails.env.development?

    halt_unsupported!
  end

  protected

  def feature_enabled?(feature_name)
    Feature.enabled?(feature_name, current_user)
  end
  helper_method :feature_enabled?

  def track_page_view
    return unless request.get?
    return if current_user&.role?(:admin)

    ahoy.track "Page view", request.path_parameters.merge(url: request.fullpath)
  end

  def configure_time_zone(&block)
    if current_team.present?
      time_zone = current_team.time_zone
    end
    Time.use_zone(time_zone, &block)
  end

  def after_sign_in_path_for(_resource)
    dashboard_path
  end

  # Used for devise confirmations and edit profile
  def user_root_path
    dashboard_path
  end

  def current_team
    current_user.team
  end
  helper_method :current_team

  def ensure_team!
    return unless user_signed_in?

    if current_user.team.blank?
      redirect_to new_team_path
    end
  end

  def create_checkout(with_plan:)
    BillingService.create_checkout(
      plan: with_plan,
      user: current_user,
      team: current_team,
      success_url: billing_success_url,
      cancel_url: billing_subscriptions_url,
    )
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name terms_and_conditions])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name avatar])
  end

  def prepare_exception_notifier
    return unless Rails.env.production?

    request.env["exception_notifier.exception_data"] = {
      current_user: current_user,
    }
  end

  def halt_not_found!
    raise ActionController::RoutingError, "Not Found"
  end

  def halt_unsupported!
    render(text: "unsupported", status: :unsupported_media_type)
  end
end
