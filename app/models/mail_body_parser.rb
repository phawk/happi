class MailBodyParser
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

    EmailReplyParser.parse_reply(text_content)
  end
end
