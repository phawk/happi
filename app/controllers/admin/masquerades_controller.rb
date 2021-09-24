module Admin
  class MasqueradesController < Devise::MasqueradesController
    def show
      super
    end

    protected

    def masquerade_authorize!
      return if params[:action] == "back"
      return redirect_to root_path unless user_signed_in?

      unless current_user.role?(:superadmin)
        flash[:error] = "You are not a superadmin"
        redirect_to root_path
      end
    end

    def after_masquerade_path_for(_resource)
      message_threads_path
    end

    def after_back_masquerade_path_for(_resource)
      admin_users_path
    end

    # or you can define:
    # def masquerade_authorized?
    #   <has access to something?> (true/false)
    # end
  end
end
