module Api
  class CustomersController < ApiController
    def create
      customer = current_team.customers.where(email: customer_email_address).first_or_initialize
      existing_record = customer.persisted?
      customer.assign_attributes(customer_params)

      if customer.save
        render json: { jwt: customer.as_jwt }, status: existing_record ? :ok : :created
      else
        render_error(customer)
      end
    end

    private

    def customer_email_address
      String(customer_params[:email]).downcase.strip
    end

    def customer_params
      params.permit(:first_name, :last_name, :email)
    end
  end
end
