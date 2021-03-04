class CustomersController < ApplicationController
  def index
    @customers = current_team.customers.order(:last_name)
  end

  def show
  end

  def new
  end

  def edit
  end
end
