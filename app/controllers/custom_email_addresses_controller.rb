class CustomEmailAddressesController < ApplicationController
  def create
    @custom_email_address = current_team.custom_email_addresses.new(custom_email_params)

    if @custom_email_address.save
      redirect_to settings_path, notice: "#{@custom_email_address.email} added"
    else
      render partial: "form", status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def custom_email_params
    params.require(:custom_email_address).permit(:email)
  end
end
