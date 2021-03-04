class DashboardController < ApplicationController
  def show
    @message_threads = current_team.message_threads.includes(:customer, :messages)
  end
end
