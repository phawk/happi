module Documentation
  class BaseController < ApplicationController
    skip_before_action :authenticate_user!
    skip_before_action :ensure_team!
    layout "documentation"
  end
end
