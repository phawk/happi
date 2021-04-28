class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :ensure_team!
  layout "marketing"

  def home; end
  def terms; end
  def privacy; end
  def security; end
end
