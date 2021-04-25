class MailBodyParser
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper

  attr_accessor :found_text_part
  attr_reader :mail

  def initialize(mail)
    @mail = mail
  end

  def content
    resp = EmailReplyParser.parse_reply(text_content)
    resp = simple_format(resp) if found_text_part
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

      if text_part = parts.find { |part| part.text? }
        self.found_text_part = true
        text_part.decoded
      else
        parts.first.decoded
      end
    else
      self.found_text_part = true
      mail.decoded
    end
  end
end
