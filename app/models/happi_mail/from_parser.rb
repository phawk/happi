module HappiMail
  class FromParser
    DEFAULT_FROM_NAME = "Unknown".freeze
    FROM_EMAIL_MATCHER = %r{[^\s<]+\@[^\s>]+}
    EMBEDDED_EMAIL_MATCHER = %r{\<[^>]+\>}

    attr_reader :mail

    def initialize(mail)
      @mail = mail
    end

    def email_address
      from_string[FROM_EMAIL_MATCHER, 0]
    end

    def name
      if from_string.match?(EMBEDDED_EMAIL_MATCHER)
        from_string.sub(EMBEDDED_EMAIL_MATCHER, "").strip
      else
        DEFAULT_FROM_NAME
      end
    rescue
      DEFAULT_FROM_NAME
    end

    private

    def from_string
      @_from_string ||= if mail.header["Reply-To"]
                          mail.header["Reply-To"].value
                        elsif mail.header["X-Original-From"]
                          mail.header["X-Original-From"].value
                        else
                          mail.header["From"].value
                        end
    end
  end
end
