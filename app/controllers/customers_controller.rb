class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]

  def index
    @customers = current_team.customers.order(:last_name)
  end

  def show
    @message_threads = @customer.message_threads.includes(:customer, :user, :messages).most_recent.limit(50).to_a
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

  def edit; end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "Customer saved."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy; end

  private

  def set_customer
    @customer = current_team.customers.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(
      :name,
      :email,
      :company,
      :phone,
      :country_code,
      :location,
      :avatar
    )
  end
end
