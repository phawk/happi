class ThreadsMailbox < ApplicationMailbox
  MATCHER = %r{(.+)@in.happi.team}
  FROM_EMAIL_MATCHER = %r{[^\s<]+\@[^\s>]+}

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
    mail.header["X-Spam-Score"]&.value&.to_f || 0.0
  end

  def email_content_with_attachments
    content = email_content

    attachments.each do |attachment|
      content += attachment
    end

    "<div>#{content}</div>"
  end

  def email_content
    MailBodyParser.new(mail).content
  end

  def attachments
    # TODO - handle this
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
      customer.name = from_name.presence || "Unknown Sender"
      customer.save!
    end

    customer
  end

  def from_email
    if mail.header["Reply-To"]
      mail.header["Reply-To"].value[FROM_EMAIL_MATCHER, 0]
    elsif mail.header["X-Original-From"]
      mail.header["X-Original-From"].value[FROM_EMAIL_MATCHER, 0]
    else
      mail.from
    end
  end

  def from_name
    if mail.header["X-Original-From"]
      mail.header["X-Original-From"].value.sub(%r{\<[^>]+\>}, "").strip
    else
      mail.header["From"].value.sub(%r{\<[^>]+\>}, "").strip
    end
  rescue
    ""
  end
end
