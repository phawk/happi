class AdminMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.notification.subject
  #
  def notification(heading, body)
    @heading = heading
    @body = body

    admins = User.admins.pluck(:email)

    mail to: admins, subject: "Admin alert: #{heading}"
  end
end
