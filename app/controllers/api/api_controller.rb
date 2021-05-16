module Api
  class ApiController < ApplicationController
    protect_from_forgery with: :null_session
    skip_before_action :authenticate_user!
    skip_before_action :ensure_team!
    before_action :current_team

    private

    def current_team
      @_team ||= Team.find_by!(publishable_key: params[:team_publishable_key])
    end

    def render_error(message, status_code: :unprocessable_entity)
      if message.is_a?(ActiveRecord::Base) || message.is_a?(ActiveModel::Model)
        errors =
          message.errors.messages.map do |field, error_messages|
            { field: field, errors: error_messages }
          end
        full_errors = message.errors.full_messages
        response = {
          error: "#{message.class.name.humanize} validation failed",
          validation_errors: errors,
          full_errors: full_errors
        }
      else
        response = { error: message.to_s }
      end
      render json: response, status: status_code
    end
  end
end
