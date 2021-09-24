class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: "yo@happi.team"
  layout "mailer"

  rescue_from Postmark::InvalidMessageError do |e|
    matches = e.message.match(/addresses: ([^\s]+)/)
    email = matches[1].sub(/\.\z/, "")
    Rails.logger.info("=" * 100)
    Rails.logger.info("Postmark failed to send to: #{email}")
    Rails.logger.info("=" * 100)
    # User.find_by!(email: email).update(email_bounced: true)
  rescue => e
    Rails.logger.error("Postmark::InvalidMessageError #{e.message}")
  end

  private

  def roadie_options
    super unless Rails.env.test?
  end
end
