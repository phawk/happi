class MailBodyParser
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper

  attr_reader :mail

  def initialize(mail)
    @mail = mail
  end

  def content
    resp = EmailReplyParser.parse_reply(text_content)

    resp = simple_format(resp) unless has_html?(resp)
    resp
  end

  def has_html?(text)
    strip_tags(text) != text
  end

  def text_content
    if mail.multipart?
      parts = mail.parts

      # Multipart emails with attachments have multipart as first part
      parts = parts.first.parts if parts.first.multipart?

      parts.find { |part| part.text? }&.decoded || parts.first.decoded
    else
      mail.decoded
    end
  end
end
