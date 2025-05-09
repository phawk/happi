class ThreadsMailbox < ApplicationMailbox
  MATCHER = /(.+)@prioritysupport.net/

  attr_reader :message_thread, :team, :reply_to

  before_processing :ensure_team!
  before_processing :assign_thread

  def process
    message = message_thread.messages.create!(
      sender: customer,
      status: "received",
      content: email_content_with_attachments,
      raw: mail.raw_source,
      original_html: original_html,
      action_mailbox_id: action_mailbox_record&.id
    )

    return if customer.blocked?

    ProcessNewMessageJob.perform_later(message)
  end

  private

  def action_mailbox_record
    ActionMailbox::InboundEmail.find_by(message_id: mail.message_id)
  end

  def original_html
    html_part = mail.all_parts.find(&:html?)
    html_part&.decoded
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
      blob = ActiveStorage::Blob.create_and_upload!(
        io: StringIO.new(attachment.body.to_s),
        filename: attachment.filename,
        content_type: content_type,
      )

      "<action-text-attachment sgid=\"#{blob.attachable_sgid}\" content-type=\"#{content_type}\" filename=\"#{attachment.filename}\"></action-text-attachment>".html_safe # rubocop:disable Layout/LineLength, Rails/OutputSafety
    end
  end

  def ensure_team!
    if (recipient = mail.recipients.find { |r| MATCHER.match?(r) })
      Rails.logger.info("Looking for team with hash: #{recipient[MATCHER, 1]}")

      @team = Team.find_by(mail_hash: recipient[MATCHER, 1])
    else
      Rails.logger.info("Looking for team with custom inbound email: #{mail.recipients.to_sentence}")

      if (custom_email = CustomEmailAddress.matching_emails(mail.recipients))
        @team = custom_email.team
        @reply_to = custom_email.email
      end
    end

    raise(TeamNotFoundError.new("Team not found for email. From: #{from_email} Recipients: #{mail.recipients.to_sentence}")) if @team.nil?
  end

  def assign_thread
    # Lookup open threads by this email, if existing, return last one, else create new.
    if customer.message_threads.with_open_status.any?
      @message_thread = customer.message_threads.with_open_status.first
      @message_thread.update(status: "open")
    else
      subject = mail.subject.presence || "[No Subject]"
      @message_thread = customer.message_threads.create!(team: team, subject: subject, reply_to: @reply_to,
        status: "open")
    end
  end

  def customer
    @customer ||= lookup_customer
  end

  def lookup_customer
    customer = Customer.where(team: team, email: from_email).first_or_initialize

    unless customer.persisted?
      customer.name = from_name.presence || HappiMail::FromParser::DEFAULT_FROM_NAME
      customer.blocked = @team.blocked_domains.blocked?(from_email)
      customer.save!
    end

    customer
  end

  def from_email
    parsed_from.email_address&.downcase
  end

  def from_name
    parsed_from.name
  end

  def parsed_from
    @_parsed_from ||= HappiMail::FromParser.new(mail)
  end

  class TeamNotFoundError < StandardError; end
end
