module HappiMail
  class FromParser
    DEFAULT_FROM_NAME = "Unknown".freeze
    FROM_EMAIL_MATCHER = /[^\s<]+\@[^\s>]+/
    EMBEDDED_EMAIL_MATCHER = /\<[^>]+\>/

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
        attempt_name_from_body.presence || DEFAULT_FROM_NAME
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

    def attempt_name_from_body
      text_content = BodyParser.new(mail).text_content
      first_name = ""
      last_name = ""

      if (first_matches = text_content.scan(/First name:[\s\n](\w+)/)&.flatten)
        first_name = first_matches.first
      end

      if (last_matches = text_content.scan(/Last name:[\s\n](\w+)/)&.flatten)
        last_name = last_matches.first
      end

      "#{first_name} #{last_name}".strip
    end
  end
end
