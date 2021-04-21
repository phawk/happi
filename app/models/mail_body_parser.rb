class MailBodyParser
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TextHelper

  attr_reader :mail

  def initialize(mail)
    @mail = mail
  end

  def content
    text_content = if mail.multipart?
                     mail.parts.find { |part| part.text? }.decoded
                   else
                     mail.decoded
                   end

    resp = EmailReplyParser.parse_reply(text_content)

    resp = simple_format(resp) unless has_html?(resp)
    resp
  end

  def has_html?(text)
    strip_tags(text) != text
  end
end
