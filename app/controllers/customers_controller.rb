class CustomersController < ApplicationController
  def index
    @customers = current_team.customers.order(:last_name)
  end

  def show
    @customer = current_team.customers.find(params[:id])
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = current_team.customers.new(customer_params)

    if @customer.save
      redirect_to @customer, notice: "Customer saved."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  private

  def customer_params
    params.require(:customer).permit(
      :name,
      :email,
      :company,
      :phone,
      :country_code,
      :location
    )
  end
end
