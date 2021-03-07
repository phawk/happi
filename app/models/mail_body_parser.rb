class MailBodyParser
  attr_reader :mail

  def initialize(mail)
    @mail = mail
  end

  def content
    if mail.multipart?
      mail.parts[0].decoded
    else
      mail.decoded
    end
  end
end
