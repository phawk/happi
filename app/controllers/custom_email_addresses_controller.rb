class CustomEmailAddressesController < ApplicationController
  def create
    @custom_email_address = current_team.custom_email_addresses.new(custom_email_params)

    if @custom_email_address.save
      TeamMailer.email_awaiting_approval(current_team, @custom_email_address.email).deliver_later

      AdminMailer.notification(
        "Custom email needs confirmed!",
        "#{current_team.name} just added #{@custom_email_address.email} and it needs confirmed."
      ).deliver_later

      redirect_to emails_settings_path, notice: t(".success", email: @custom_email_address.email)
    else
      render partial: "form", status: :unprocessable_entity
    end
  end

  def destroy
    custom_email = current_team.custom_email_addresses.find(params[:id])
    custom_email.destroy
    redirect_to emails_settings_path, notice: t(".removed", email: custom_email.email)
  end

  private

  def custom_email_params
    params.require(:custom_email_address).permit(:email, :from_name)
  end
end
