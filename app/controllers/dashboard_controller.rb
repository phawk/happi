class DashboardController < ApplicationController
  def show
    redirect_to message_threads_path
  end
end
