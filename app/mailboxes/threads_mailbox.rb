class ThreadsMailbox < ApplicationMailbox
  MATCHER = %r{(.+)@in.happi.team}

  attr_reader :message_thread, :team, :reply_to

  before_processing :ensure_team!
  before_processing :assign_thread

  def process
    message = message_thread.messages.create!(
      sender: customer,
      status: "received",
      content: email_content_with_attachments,
      spam_score: spam_score
    )

    TeamMailer.new_message(message).deliver_later unless customer.blocked?
  end

  private

  def spam_score
    mail.header["X-Spam-Score"]&.value&.to_f
  end

  def email_content_with_attachments
    content = email_content

    attachments.each do |attachment|
      content += attachment
    end

    "<div>#{content}</div>"
  end

  def email_content
    HappiMail::BodyParser.new(mail).content
  end

  def attachments
    mail.attachments.map do |attachment|
      content_type = attachment.content_type.split(";").first
      blob = ActiveStorage::Blob.create_after_upload!(
        io: StringIO.new(attachment.body.to_s),
        filename: attachment.filename,
        content_type: content_type,
      )

      "<action-text-attachment sgid=\"#{blob.attachable_sgid}\" content-type=\"#{content_type}\" filename=\"#{attachment.filename}\"></action-text-attachment>".html_safe
    end
  end

  def ensure_team!
    if recipient = mail.recipients.find { |r| MATCHER.match?(r) }
      Rails.logger.info("Looking for team with hash: #{recipient[MATCHER, 1]}")

      @team = Team.find_by(mail_hash: recipient[MATCHER, 1])
    else
      Rails.logger.info("Looking for team with custom inbound email: #{mail.recipients.to_sentence}")

      if custom_email = CustomEmailAddress.matching_emails(mail.recipients)
        @team = custom_email.team
        @reply_to = custom_email.email
      end
    end

    bounce_with(TeamMailer.not_found(from_email)) if @team.nil?
  end

  def assign_thread
    # Lookup open threads by this email, if existing, return last one, else create new.
    if customer.message_threads.with_open_status.any?
      @message_thread = customer.message_threads.with_open_status.first
      @message_thread.update(status: "open")
    else
      @message_thread = customer.message_threads.create!(team: team, subject: mail.subject, reply_to: @reply_to, status: "open")
    end
  end

  def customer
    @customer ||= lookup_customer
  end

  def lookup_customer
    customer = Customer.where(team: team, email: from_email).first_or_initialize

    unless customer.persisted?
      customer.name = from_name
      customer.save!
    end

    customer
  end

  def from_email
    parsed_from.email_address
  end

  def from_name
    parsed_from.name
  end

  def parsed_from
    @_parsed_from ||= HappiMail::FromParser.new(mail)
  end
end
